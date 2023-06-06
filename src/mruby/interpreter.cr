# This file is part of rj
#
# SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require "./class"
require "./libmruby"

module MRuby
  # The Interpreter class nicely wraps the mruby interpreter.
  #
  # Example usage:
  #
  # ```
  # rb = Interpreter.new
  #
  # unless rb.exec("puts 'Hello' * 5")
  #   rb.print_error
  #   return false
  # end
  # ```
  class Interpreter
    getter state

    # Constructs a new mruby interpreter.
    def initialize
      @state = LibMRuby.mrb_open
      raise "invalid mrb_state" if @state.null?

      @context = LibMRuby.mrbc_context_new(@state)
      raise "invalid mrbc_context" if @context.null?
    end

    def finalize
      LibMRuby.mrbc_context_free(@state, @context)
      LibMRuby.mrb_close(@state)
    end

    def print_error
      # TODO: mrb_undef_p(@lastval)
      LibMRuby.mrb_print_error(@state)
    end

    # Evaluates the Ruby expression `command`.
    #
    # WARNING: If the expression fails to run you will **not** be able to
    # evaluate another expression afterwards.
    # See also `Interpreter#print_error`
    #
    # Returns `true` if the code was run successfully, `false` otherwise.
    def eval(command : String) : Bool
      @lastval = LibMRuby.mrb_load_nstring_cxt(@state, command, command.size, @context)

      @state.value.exc.null?
    end

    # Loads the mruby binary at `buffer`.
    def load_irep(buffer : Array(UInt8)) : LibMRuby::Value
      ai = MRuby.mrb_gc_arena_save(@state)
      status = LibMRuby.mrb_load_irep_buf_cxt(@state, buffer, buffer.size, @context)
      MRuby.mrb_gc_arena_restore(@state, ai)

      status
    end

    # Returns the class named `name`.
    def class_get(name : String) : Class?
      mrb_class = LibMRuby.mrb_class_get(@state, name)
      return if mrb_class.null?

      Class.new(self, mrb_class)
    end

    def symbol(name : String) : LibMRuby::Symbol
      LibMRuby.mrb_intern_cstr(@state, name)
    end
  end
end
