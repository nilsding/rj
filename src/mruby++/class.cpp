#include "class.h"
#include "interpreter.h"

#include <mruby/variable.h>

namespace MRuby
{

Class::Class(Interpreter* rb, struct RClass* klass)
: m_rb{rb}
, m_class{klass}
{}

Class::~Class()
{
    // nothing to do here
}

void Class::ivar_set(std::string_view name, mrb_value value)
{
    ivar_set(m_rb->symbol(name), value);
}

void Class::ivar_set(mrb_sym name, mrb_value value)
{
    mrb_obj_iv_set(m_rb->state(), reinterpret_cast<struct RObject*>(m_class), name, value);
}

}
