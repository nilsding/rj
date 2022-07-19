# This module allows for navigating a Hash like calling a method.
#
# Example usage:
#
#   my_hash = {
#     fruits: {
#       apple:     { colour: "red", tasty: true },
#       "lemon" => { colour: "yellow", tasty: true },
#     }
#   }
#
#   my_hash.fruits.apple.colour  # => "red"
#   my_hash.fruits.lemon.colour  # => "yellow"
#   my_hash.fruits.bnana.colour  # NoMethodError
#
# Note: this only works if there isn't already a method defined that has the
# same name as the key:
#
#   my_hash = {
#     first:  1,
#     second: 2,
#   }
#
#   # uses Enumerable#first:
#   my_hash.first   # => [:first, 1]
#   # works as you expect:
#   my_hash.second  # => 2
module MethodAccessor
  def method_missing(symbol, *args)
    super unless respond_to_missing?(symbol)

    self[symbol.to_s] || self[symbol]
  end

  def respond_to_missing?(symbol, include_private = false)
    return true if self.keys.map(&:to_s).include?(symbol.to_s)

    false
  end
end

Hash.prepend MethodAccessor
