#pragma once

#include <string>

class ExpressionWrapper
{
public:
    //!
    //! \brief Wraps the Ruby expression \a expr with some extra Ruby code to
    //! allow chaining expressions more easily.
    //!
    //! The Ruby expression gets wrapped as follows:
    //! - If \a expr starts with a dot `.` or a `[`, `item` is prepended
    //! - Then the entire expression is wrapped in parenthesis
    //! - Finally it is prefixed with `item =`.
    //!
    //! When \a expr is an empty string the resulting expression is just
    //! `item`.
    //! \param expr Ruby expression to wrap, e.g. (`.first`).
    //! \return The wrapped Ruby expression (e.g. `item = (item.first)`).
    static std::string wrap(const std::string_view& expr);
};
