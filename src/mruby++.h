#pragma once

#include "mruby.h"
#include "mruby/compile.h"

#include <string_view>

class MRuby
{
public:
    explicit MRuby();
    ~MRuby();

    mrb_state* state() const;
    struct RObject* exc() const;

    void print_error();

    bool eval(const std::string_view& command);

private:
    mrb_state* m_state = nullptr;
    mrbc_context* m_context = nullptr;
    mrb_value m_lastval;
};
