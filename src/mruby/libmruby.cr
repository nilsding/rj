# This file is part of rj
#
# SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

module MRuby
  @[Link(ldflags: "-L#{__DIR__}/../../vendor/mruby/build/host/lib -lmruby -lm")]
  lib LibMRuby
    # stub types as we only deal with pointers
    type JmpBuf = Void
    type Context = Void
    type IvTbl = Void
    type RObject = Void
    type RClass = Void
    type RBasic = Void
    type RProc = Void

    # from mruby/value.h:
    type Symbol = UInt32

    # from mruby/boxing_word.h (default boxing type):
    {% if Defines::MRB_WORD_BOXING %}
      enum SpecialConsts
        Qnil   =  0
        Qfalse =  4
        Qtrue  = 12
        Qundef = 20
      end

      struct Value
        # uintptr_t is a ULong on arm64 darwin
        w : LibC::ULong
      end
    {% else %}
      {% raise "only MRB_WORD_BOXING is supported" %}
    {% end %}

    {% unless Defines::MRB_USE_METHOD_T_STRUCT %}
      # uintptr_t is a ULong on arm64 darwin
      type Method = LibC::ULong
    {% else %}
      struct Method
        flags : UInt8
        union ProcOrFunc
          proc : RProc*
          func : FuncT
        end
      end
    {% end %}

    {% unless Defines::MRB_NO_METHOD_CACHE %}
      struct CacheEntry
        c : RClass*
        c0 : RClass*
        mid : Symbol
        m : Method
      end
    {% end %}

    # some info about this struct is required, as we need to pass certain fields
    # (e.g. `exc`) to functions
    struct State
      jmp : JmpBuf*

      allocf : (State*, Void*, LibC::SizeT, Void*) -> Void*
      allocf_ud : Void*

      c : Context*
      root_c : Context*
      globals : IvTbl*

      exc : RObject*

      top_self : RObject*
      object_class : RClass*
      class_class : RClass*
      module_class : RClass*
      proc_class : RClass*
      string_class : RClass*
      array_class : RClass*
      hash_class : RClass*
      range_class : RClass*

      {% unless Defines::MRB_NO_FLOAT %}
        float_class : RClass*
      {% end %}
      integer_class : RClass*
      true_class : RClass*
      false_class : RClass*
      nil_class : RClass*
      symbol_class : RClass*
      kernel_module : RClass*

      gc : GC

      {% unless Defines::MRB_NO_METHOD_CACHE %}
        cache : CacheEntry[MRB_METHOD_CACHE_SIZE]
      {% end %}

      symidx : Symbol
      symtbl : LibC::Char**
      symlink : UInt8
      symflags : UInt8
      symhash : Symbol[256]
      symcapa : LibC::SizeT
      {% unless Defines::MRB_USE_ALL_SYMBOLS %}
        symbuf : LibC::Char[8]
      {% end %}

      {% if Defines::MRB_USE_DEBUG_HOOK %}
        {% raise "MRB_USE_DEBUG_HOOK is currently not supported" %}
      {% end %}

      {% if Defines::MRB_BYTECODE_DECODE_OPTION %}
        {% raise "MRB_BYTECODE_DECODE_OPTION is currently not supported" %}
      {% end %}

      eException_class : RClass*
      eStandardError_class : RClass*
      nomem_err : RObject*
      stack_err : RObject*
      {% if Defines::MRB_GC_FIXED_ARENA %}
        arena_err : RObject*
      {% end %}

      ud : Void*
      # TODO: MRB_FIXED_STATE_ATEXIT_STACK
    end

    # type alias needs to be after the `State` struct
    type FuncT = (State*, Value) -> Value

    fun mrb_open : State*
    fun mrb_close(State*)
    fun mrbc_context_new(State*) : Context*
    fun mrbc_context_free(State*, Context*)
    fun mrb_class_get(mrb : State*, name : LibC::Char*) : RClass*
    fun mrb_intern_cstr(mrb : State*, str : LibC::Char*) : Symbol
    fun mrb_print_error(State*)

    # from mruby/gc.h:
    enum GCState
      Root  = 0
      Mark
      Sweep
    end
    type HeapPage = Void

    struct GC
      heaps : HeapPage*
      sweeps : HeapPage*
      free_heaps : HeapPage*
      live : LibC::SizeT
      {% if Defines::MRB_GC_FIXED_ARENA %}
        {% raise "MRB_GC_FIXED_ARENA is currently not supported" %}
      {% else %}
        arena : RBasic**
        arena_capa : LibC::Int
      {% end %}
      arena_idx : LibC::Int

      state : GCState
      current_white_part : LibC::Int
      gray_list : RBasic*
      atomic_gray_list : RBasic*
      live_after_mark : LibC::SizeT
      threshold : LibC::SizeT
      interval_ratio : LibC::Int
      step_ratio : LibC::Int
      iterating : Bool
      disabled : Bool
      full : Bool
      generational : Bool
      out_of_memory : Bool
      majorgc_old_threshold : LibC::SizeT
    end

    # from mruby/compile.h:
    fun mrb_load_nstring_cxt(mrb : State*, s : LibC::Char*, len : LibC::SizeT, cxt : Context*) : Value

    # from mruby/irep.h:
    fun mrb_load_irep_buf_cxt(State*, Void*, LibC::SizeT, Context*) : Value

    # from mruby/variable.h:
    fun mrb_obj_iv_set(mrb : State*, obj : RObject*, sym : Symbol, v : Value) : Void
  end

  def self.mrb_gc_arena_save(mrb : LibMRuby::State*) : Int
    mrb.value.gc.arena_idx
  end

  def self.mrb_gc_arena_restore(mrb : LibMRuby::State*, idx : Int)
    mrb.value.gc.arena_idx = idx
  end

  # turns a bool into a mrb_value
  def self.value(val : Bool) : LibMRuby::Value
    # mruby/value.h
    v = LibMRuby::Value.new
    # SET_BOOL_VALUE from mruby/boxing_word.h
    const_val = if val
                  # SET_TRUE_VALUE
                  LibMRuby::SpecialConsts::Qtrue
                else
                  # SET_FALSE_VALUE
                  LibMRuby::SpecialConsts::Qfalse
                end
    v.w = const_val
    v
  end

  # turns a symbol into a mrb_value
  def self.value(val : LibMRuby::Symbol) : LibMRuby::Value
    # mruby/value.h
    v = LibMRuby::Value.new
    # mruby/boxing_word.h:
    # SET_SYM_VALUE -> WORDBOX_SET_SHIFT_VALUE(mrb_value, SYMBOL, mrb_sym)
    # TODO: u64?  what to do on 32bit systems?
    wordboxed_value = (val.to_u64 << WORDBOX_SYMBOL_SHIFT) | WORDBOX_SYMBOL_FLAG
    v.w = wordboxed_value
    v
  end
end
