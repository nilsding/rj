module RubyFormatter
  def self.generate(item, pretty_print: false, indent_width: 2)
    return item.inspect unless pretty_print

    Formatter.new(item, indent_width:).pretty_please
  end

  class Formatter
    attr_reader :item, :indent_width, :level, :indent

    def initialize(item, indent_width:)
      @item = item
      @indent_width = indent_width

      self.level = 0
    end

    def level=(level)
      @level = level
      @indent = ' ' * (indent_width * level)
    end

    def pretty_please(obj = @item)
      buf = []

      case obj
      when Hash
        return "{}" if obj.empty?

        buf << "{\n"
        self.level += 1
        obj.each do |key, value|
          buf << indent << key.inspect << " => " << pretty_please(value) << ",\n"
        end
        self.level -= 1
        buf << indent << "}"
      when Array
        return "[]" if obj.empty?

        buf << "[\n"
        self.level += 1
        obj.each do |elem|
          buf << indent << pretty_please(elem) << ",\n"
        end
        self.level -= 1
        buf << indent << "]"
      else
        buf << obj.inspect
      end

      buf.join
    end
  end
end
