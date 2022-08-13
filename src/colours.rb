# module handling colourful output
module Colours
  # contains a mapping of "type => ANSI colour"
  COLOURS = {
    true:   "0;32",
    false:  "0;31",
    nil:    "1;31",
    number: "0;36",
    string: "0;35",
    symbol: "0;33",
    none:   "0",
  }

  module Colourise
    def colourise(code) = "\033[#{COLOURS.fetch(code, code)}m#{self}\033[0m"

    # Colourise based on the type of `obj`
    def colourise_obj(obj) =
      colourise(
        case obj
        when true
          :true
        when false
          :false
        when nil
          :nil
        when Numeric
          :number
        when String
          :string
        when Symbol
          :symbol
        else
          :none
        end
      )
  end

  module Monochromise
    def colourise(_) = self.to_s

    def colourise_obj(_) = colourise(:none)
  end

  # Enables/disables coloured output
  def self.enable!
    mod = if Rj.colour?
            Colourise
          else
            Monochromise
          end

    String.prepend(mod)
  end
end
