module JSON
  # based on:
  # https://github.com/iij/mruby-iijson/blob/c5e730c30090d3cddae258f57ab9508edb3e9fce/mrblib/json.rb#L28
  #
  # patched to support coloured output
  def self.generate0(obj, options, state)
    if state[:nesting] >= state[:max_nesting]
      raise JSON::NestingError, "nesting of #{state[:nesting]} is too deep"
    end

    pretty = options[:pretty_print]

    if pretty
      indent = options[:indent_with].class == Fixnum ? " " * options[:indent_with] : options[:indent_with]
    else
      indent = ""
    end

    nl = pretty ? "\n" : ""

    if obj == false
      return "false".colourise(:false)

    elsif obj == nil
      return "null".colourise(:nil)

    elsif obj == true
      return "true".colourise(:true)

    elsif obj.is_a? Hash
      members = []
      state[:nesting] += 1
      obj.each { |k, v|
        members << JSON.generate0(k, options, state) + ":" + (pretty ? " " : "") + JSON.generate0(v, options, state)
      }
      if pretty
        members.map! { |k| (indent * state[:nesting]) + "#{k}" }.join("_")
      end
      state[:nesting] -= 1
      return "{" + nl + members.join("," + nl) + nl + (indent * state[:nesting]) + "}"

    elsif obj.is_a? Array
      state[:nesting] += 1
      members = obj.map { |v| JSON.generate0(v, options, state) }
      if pretty
        members.map! { |k| (indent * state[:nesting]) + "#{k}" }.join("_")
      end
      state[:nesting] -= 1
      return "[" + nl + members.join("," + nl) + nl + (indent * state[:nesting]) + "]"

    elsif obj.is_a? Fixnum
      return obj.to_s.colourise(:number)

    elsif obj.is_a? Float
      if obj.infinite? or obj.nan?
        raise GeneratorError, "#{obj.to_s} not allowed in JSON"
      end
      return (sprintf "%.17g", obj).colourise(:number)

    else
      a = []
      obj.to_s.each_char { |ch|
        a << if ch < "\x20"
          case ch
          when "\x08"
            "\\b"
          when "\x0c"
            "\\f"
          when "\x0a"
            "\\n"
          when "\x0d"
            "\\r"
          when "\x09"
            "\\t"
          else
            raise GeneratorError, "cannot convert #{ch.inspect} to JSON"
          end
        elsif ch == '"'
          '\\"'
        elsif ch == '\\'
          "\\\\"
        else
          ch
        end
      }
      return ('"' + a.join + '"').colourise(:string)
    end
  end
end
