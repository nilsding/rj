#include "interpreter.h"
#include "class.h"

#include <iostream>
#include <stdexcept>

#include <mruby/irep.h>

namespace MRuby
{

Interpreter::Interpreter()
: m_state(mrb_open())
, m_context(mrbc_context_new(m_state))
{
    if (m_state == nullptr)
    {
        throw std::runtime_error("invalid mrb_state");
    }

    if (m_context == nullptr)
    {
        throw std::runtime_error("invalid mrbc_context");
    }
}

Interpreter::~Interpreter()
{
    mrbc_context_free(m_state, m_context);
    mrb_close(m_state);
}

mrb_state* Interpreter::state() const
{
    return m_state;
}

struct RObject* Interpreter::exc() const
{
    return m_state->exc;
}

void Interpreter::print_error()
{
    if (mrb_undef_p(m_lastval))
    {
        return;
    }

    mrb_print_error(m_state);
}

bool Interpreter::eval(std::string_view command)
{
    m_lastval = mrb_load_nstring_cxt(m_state, command.data(), command.length(), m_context);

    return exc() == 0;
}

mrb_value Interpreter::load_irep(const uint8_t buffer[])
{
    int ai = mrb_gc_arena_save(m_state);
    mrb_value status = mrb_load_irep_cxt(m_state, buffer, m_context);
    mrb_gc_arena_restore(m_state, ai);

    return status;
}

Class* Interpreter::class_get(std::string_view name)
{
    struct RClass* mrb_class = mrb_class_get(m_state, std::string{name}.c_str());
    if (mrb_class == nullptr)
    {
        return nullptr;
    }

    return new Class(this, mrb_class);
}

mrb_sym Interpreter::symbol(std::string_view name)
{
    return mrb_intern_cstr(m_state, std::string{name}.c_str());
}

}
