#include "mruby++.h"
#include "mruby/compile.h"

#include <iostream>
#include <stdexcept>

MRuby::MRuby()
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

MRuby::~MRuby()
{
    mrbc_context_free(m_state, m_context);
    mrb_close(m_state);
}

mrb_state* MRuby::state() const
{
    return m_state;
}

struct RObject* MRuby::exc() const
{
    return m_state->exc;
}

void MRuby::print_error()
{
    if (mrb_undef_p(m_lastval))
    {
        return;
    }

    mrb_print_error(m_state);
}

bool MRuby::eval(const std::string_view &command)
{
    m_lastval = mrb_load_nstring_cxt(m_state, command.data(), command.length(), m_context);

    return exc() == 0;
}
