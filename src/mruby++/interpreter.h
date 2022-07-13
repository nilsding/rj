#pragma once

#include "mruby.h"
#include "mruby/compile.h"

#include <string_view>

namespace MRuby
{

class Class;

//! \brief The Interpreter class nicely wraps the mruby interpreter.
//!
//! Example usage:
//!
//! ```cpp
//! MRuby rb;
//!
//! if (!rb.exec("puts 'Hello' * 5"))
//! {
//!     rb.print_error();
//!     return false;
//! }
//! ```
class Interpreter
{
public:
    //! \brief Constructs a new mruby interpreter.
    //! \exception std::runtime_error when mruby initialisation fails.
    explicit Interpreter();
    ~Interpreter();

    //! \brief Returns the interpreter wrapped by this class.
    mrb_state* state() const;
    //! \brief Returns the last \c Exception thrown by the interpreter.
    struct RObject* exc() const;

    //! \brief Prints the error backtrace from a former exception.
    void print_error();

    //! \brief Evaluates the Ruby expression \a command.
    //!
    //! \warning If the expression fails to run you will \b not be able to
    //! evaluate another expression afterwards.
    //! \sa MRuby::print_error
    //! \return \c true if the code was run successfully, \c false otherwise.
    bool eval(std::string_view command);

private:
    mrb_state* m_state = nullptr;
    mrbc_context* m_context = nullptr;
    mrb_value m_lastval;
};

}

