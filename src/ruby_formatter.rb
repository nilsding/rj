module RubyFormatter
  def self.generate(item, pretty_print: false, indent_width: 2)
    Formatter.new(item, pretty_print:, indent_width:).pretty_please
  end

  class Formatter
    attr_reader :item, :pretty_print, :indent_width, :level, :indent, :newline, :hash_rocket

    def initialize(item, pretty_print:, indent_width:)
      @item = item
      @pretty_print = pretty_print
      @indent_width = indent_width

      self.level = 0

      if pretty_print
        @newline = "\n"
        @hash_rocket = " => "
      else
        @newline = ""
        @hash_rocket = "=>"
      end
    end

    def level=(level)
      @level = level
      return unless pretty_print # no need for adjusting indentation in compact mode

      @indent = ' ' * (indent_width * level)
    end

    def pretty_please(obj = @item)
      buf = []

      case obj
      when Hash
        return "{}" if obj.empty?

        buf << "{" << newline
        self.level += 1
        obj.each do |key, value|
          buf << indent << key.inspect.colourise_obj(key) << hash_rocket << pretty_please(value) << "," << newline
        end

        # remove last newline ("\n" or "") and ","
        buf.pop
        buf.pop
        # add the newline again
        buf << newline

        self.level -= 1
        buf << indent << "}"
      when Array
        return "[]" if obj.empty?

        buf << "[" << newline
        self.level += 1
        obj.each do |elem|
          buf << indent << pretty_please(elem) << "," << newline
        end

        # remove last newline ("\n" or "") and ","
        buf.pop
        buf.pop
        # add the newline again
        buf << newline

        self.level -= 1
        buf << indent << "]"
      else
        buf << obj.inspect.colourise_obj(obj)
      end

      buf.join
    end
  end
end
