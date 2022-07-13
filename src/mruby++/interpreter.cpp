#include "interpreter.h"

#include "class.h"

#include <iostream>
#include <stdexcept>

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

}

