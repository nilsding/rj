# This file is part of rj
#
# SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

module ExpressionWrapper
  # Wraps the Ruby expression `expr` with some extra Ruby code to allow
  # chaining expressions more easily.
  #
  # The Ruby expression gets wrapped as follows:
  # - If `expr` starts with a dot `.` or a `[`, `item` is prepended
  # - Then the entire expression is wrapped in parenthesis
  # - Finally it is prefixed with `item =`.
  #
  # When `expr` is an empty string the resulting expression is just `item`.
  # @param expr Ruby expression to wrap, e.g. (`.first`).
  # @return The wrapped Ruby expression (e.g. `item = (item.first)`).
  def self.wrap(expr : String)
    # nothing to do for empty strings, just return the item again ...
    return "item" if expr.size == 0

    # expression starts with a '.' or '[' --> prefix it with just 'item'
    expr = "item#{expr}" if expr[0] == '.' || expr[0] == '['

    # wrap the string in parenthesis and prefix it with 'item =' again to
    # reassign it
    "item = (#{expr})"
  end
end
