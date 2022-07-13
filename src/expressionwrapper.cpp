#include "expressionwrapper.h"

std::string ExpressionWrapper::wrap(std::string_view expr)
{
    if (expr.length() == 0)
    {
        // nothing to do for empty strings, just return the item again ...
        return "item";
    }

    std::string str{expr};

    // expression starts with a '.' or '[' --> prefix it with just 'item'
    if (expr[0] == '.' || expr[0] == '[')
    {
        str.insert(0, "item");
    }

    // wrap the string in parenthesis
    str.insert(0, "(");
    str.append(")");

    // finally prefix the string with 'item =' again to reassign it.
    str.insert(0, "item = ");

    return str;
}
