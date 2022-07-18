class Rj
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
    compact: @compact,
    debug: @debug,
    output_format:,
    ruby: MRUBY_DESCRIPTION,
  }
end
