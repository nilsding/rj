# This file is part of rj
#
# SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

module Rj
  VERSION = "0.5.0"
end

require "./expression_wrapper"
require "./mruby"

require "option_parser"

struct ProgramOptions
  # `-C`: `true` if the output should be colourised.  if `-M` (monochrome) is given this will be set to `false`.
  property colour : Bool = STDOUT.tty?
  # `-c`: `true` if the JSON should be compacted instead of pretty printed
  property compact = false
  # `-d`: `true` if you want debug output
  property debug = false
  # `-h`: `true` if the program should exit with its usage info.
  property help = false
  # `-v`: `true` if the program should exit with its version info.
  property version = false

  # `-o`: the output format, default: `"json"`
  property output_format = "json"

  # a list of Ruby expressions to evaluate in the given order.
  property expressions = [] of String
end

opts = ProgramOptions.new

parser = OptionParser.new do |parser|
  parser.banner = "Usage: rj [options] [--] [EXPRESSION...]"
  parser.on("-C", "coloured output (default if the output is a terminal)") do
    opts.colour = true
  end
  parser.on("-M", "monochrome output") do
    opts.colour = false
  end
  parser.on("-c", "compact the JSON instead of pretty printing it") do
    opts.compact = true
  end
  parser.on("-d", "extra debug output") do
    opts.debug = true
  end
  parser.on("-o FORMAT", <<-EOF.gsub(/^ +/m, "")) do |output_format|
    print the result in FORMAT
    supported formats: json (default), ruby, plain
  EOF
    opts.output_format = output_format
  end
  parser.on("-r", "output raw texts, same as '-o plain'") do
    opts.output_format = "plain"
  end
  parser.on("-v", "--version", "print the version number") do
    opts.version = true
  end
  parser.on("-h", "--help", "show this message") do
    opts.help = true
  end
  parser.unknown_args do |_args|
    # just use all of ARGV, all other arguments are already consumed
    opts.expressions = ARGV
  end
end

debug_output : IO = STDERR

class NullIO < IO
  def read(slice : Bytes)
    0
  end

  def write(slice : Bytes) : Nil
  end
end

MRuby.precompile!(MRBC_RJ, "./src/rj.rb")
MRuby.precompile!(MRBC_RUBY_FORMATTER, "./src/ruby_formatter.rb")
MRuby.precompile!(MRBC_METHOD_ACCESSOR, "./src/method_accessor.rb")
MRuby.precompile!(MRBC_COLOURS, "./src/colours.rb")
MRuby.precompile!(MRBC_JSON_EXT, "./src/json_ext.rb")

begin
  parser.parse

  if opts.help
    puts parser
    exit 0
  end

  if opts.version
    puts "rj #{Rj::VERSION} (mruby #{MRuby::MRUBY_VERSION})"
    exit 0
  end

  debug_output = NullIO.new unless opts.debug

  rb = MRuby::Interpreter.new

  debug_output.puts "loading Rj class"
  rb.load_irep(MRBC_RJ)
  # {% puts read_file("./src/rj.rb").stringify %}
  # unless rb.eval({{ read_file("./src/rj.rb").stringify }})
  #   STDERR.puts "rj: init failed:"
  #   rb.print_error
  #
  #   exit 1
  # end
  # rb.eval("puts Rj, :colour.object_id, :end.object_id, :@colour.object_id")
  # debug_output.puts "aaaaa"
  rj_class = rb.class_get("Rj").not_nil!
  rj_class.ivar_set("@colour", MRuby.value(opts.colour))
  rj_class.ivar_set("@compact", MRuby.value(opts.compact))
  rj_class.ivar_set("@debug", MRuby.value(opts.debug))
  rj_class.ivar_set("@output_format", opts.output_format)
  rb.load_irep(MRBC_RUBY_FORMATTER)
  rb.load_irep(MRBC_METHOD_ACCESSOR)
  rb.load_irep(MRBC_COLOURS)
  rb.load_irep(MRBC_JSON_EXT)

  debug_output.puts "reading from stdin"
  unless rb.eval("item = JSON.parse(STDIN.read)")
    STDERR.puts "rj: read from stdin failed:"
    rb.print_error

    exit 1
  end

  debug_output.puts "running #{opts.expressions.size} expressions"
  opts.expressions.each do |expr|
    wrapped_expr = ExpressionWrapper.wrap(expr)
    debug_output.puts "----> #{wrapped_expr}"
    unless rb.eval(wrapped_expr)
      STDERR.puts "rj: expression #{expr.inspect} failed to run:"
      rb.print_error

      exit 1
    end
  end

  debug_output.puts "printing item"
  unless rb.eval("Rj.print_result(item)")
    STDERR.puts "rj: printing item failed"
    rb.print_error

    exit 1
  end
rescue ex : Exception
  STDERR.puts "rj: #{ex.message} (#{ex.class})"
  STDERR.puts
  STDERR.puts parser
  exit 1
end

exit 0
