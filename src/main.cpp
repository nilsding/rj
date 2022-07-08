#include "config.h"

#include <iostream>
#include <iterator>
#include <string_view>
#include <vector>

struct ProgramOptions
{
    ProgramOptions(int argc, char** argv);
    bool valid = true;

    bool help = false;
    bool version = false;

    std::vector<std::string_view> expressions;
};

ProgramOptions::ProgramOptions(int argc, char** argv)
{
    std::vector<std::string_view> args(argv + 1, argv + argc);

    // scan for options
    auto it = args.begin();
    while (it != args.end())
    {
        auto arg = *it;

        if (arg.length() == 0) // skip empty arguments
        {
            ++it; // advance to the next argument before restarting the loop
            continue;
        }

        if (arg == "--") // every other arg is an expression
        {
            it = args.erase(it); // remove the current arg from the list as we already processed it
            break;
        }

        // special handling for GNU-style help options
        if (arg == "--help")
        {
            help = true;
            it = args.erase(it); // remove the current arg from the list as we already processed it
            continue;
        }
        if (arg == "--version")
        {
            version = true;
            it = args.erase(it); // remove the current arg from the list as we already processed it
            continue;
        }

        if (arg.length() > 1 && arg[0] == '-')
        {
            auto argit = arg.begin();
            ++argit;
            for (; argit != arg.end(); ++argit)
            {
                switch (*argit)
                {
                case 'h':
                    help = true;
                    break;
                case 'v':
                    version = true;
                    break;
                default:
                    throw std::runtime_error(std::string("invalid option -") + *argit);
                }
            }

            it = args.erase(it); // remove the current arg from the list as we already processed it
            continue;
        }

        ++it; // advance to the next argument before restarting the loop
    }

    // the remaining args are our expressions
    expressions = args;
}

void print_version(std::ostream& stream = std::cout)
{
    stream << "rq " << PROJECT_VERSION << std::endl;
}

void print_usage(std::ostream& stream = std::cout)
{
    stream << R"(Usage: rq [options] [--] [EXPRESSION...]
  -v              print the version number
  -h              show this message)" << std::endl;
}

int main(int argc, char** argv)
{
    try
    {
        ProgramOptions opts(argc, argv);
        if (opts.help)
        {
            print_usage();
            return EXIT_SUCCESS;
        }

        if (opts.version)
        {
            print_version();
            return EXIT_SUCCESS;
        }

        std::cout << "Got " << opts.expressions.size() << " expressions:" << std::endl;
        for (const auto& expr : opts.expressions)
        {
            std::cout << "- " << expr << std::endl;
        }
    }
    catch (const std::exception &ex)
    {
        std::cerr << "rq: " << ex.what() << std::endl << std::endl;
        print_usage(std::cerr);
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
