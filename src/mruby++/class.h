/*
    This file is part of rj

    SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#pragma once

#include <mruby.h>

#include <string_view>

namespace MRuby
{

class Interpreter;

//! \brief Represents a mruby class.
class Class
{
public:
    explicit Class(Interpreter* rb, struct RClass* klass);
    ~Class();

    void ivar_set(std::string_view name, std::string_view value);
    void ivar_set(std::string_view name, mrb_value value);
    void ivar_set(mrb_sym name, mrb_value value);

private:
    Interpreter* m_rb = nullptr;
    struct RClass* m_class = nullptr;
};

}
