# This file is part of rj
#
# SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require "./interpreter"
require "./libmruby"

module MRuby
  # Represents an mruby class.
  class Class
    def initialize(@rb : Interpreter, @klass : LibMRuby::RClass*)
    end

    def ivar_set(name : String, value : String) : Nil
      ivar_set(@rb.symbol(name), MRuby.value(@rb.symbol(value)))
    end

    def ivar_set(name : String, value : LibMRuby::Value) : Nil
      ivar_set(@rb.symbol(name), value)
    end

    def ivar_set(name : LibMRuby::Symbol, value : LibMRuby::Value) : Nil
      LibMRuby.mrb_obj_iv_set(@rb.state, @klass.as(LibMRuby::RObject*), name, value)
    end
  end
end
