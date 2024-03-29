# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

class Rj
  # Returns `true` if the output should be colourised.
  def self.colour? = @colour

  # Returns `true` if the final output should be compact, `false` if it should
  # be pretty printed.
  def self.compact? = @compact

  # Returns `true` if the debug flag (`-d`) was enabled.
  def self.debug? = @debug

  # Returns the requested output format (default: `:json`)
  def self.output_format = @output_format || :json

  # Prints the result of `item`.
  def self.print_result(item)
    generate_opts = {
      pretty_print: !compact?,
      indent_width: 2,
    }

    Colours.enable!

    case output_format
    when :json
      puts JSON.generate(item, **generate_opts)
    when :ruby
      puts RubyFormatter.generate(item, **generate_opts)
    when :plain
      puts item
    else
      raise ArgumentError, "Unknown output format: #{output_format}"
    end
  end

  # Method that returns whatever debug info I like.
  def self.__debug_info = {
    colour: @colour,
    compact: @compact,
    debug: @debug,
    output_format:,
    ruby: MRUBY_DESCRIPTION,
  }
end
