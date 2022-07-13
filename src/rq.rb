class Rq
  # Returns `true` if the final output should be compact, `false` if it should
  # be pretty printed.
  def self.compact? = @compact

  # Prints the result of `item`.
  def self.print_result(item)
    json_generate_opts = {
      pretty_print: !compact?,
      indent_width: 2,
    }

    puts JSON.generate(item, **json_generate_opts)
  end

  # Method that returns whatever debug info I like.
  def self.__debug_info = {
    compact: @compact,
    ruby: MRUBY_DESCRIPTION,
  }
end
