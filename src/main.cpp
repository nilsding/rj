#include "config.h"

#include <iomanip>
#include <iostream>
#include <iterator>
#include <string_view>
#include <vector>

#include "expressionwrapper.h"
#include "mruby++.h"

static std::ostream* Debug = &std::cerr;

extern const uint8_t mrbc_rq[];
extern const uint8_t mrbc_ruby_formatter[];

//! \brief Parses and represents command line arguments.
struct ProgramOptions
{
    //! \brief Parse command line arguments and return a new \c ProgramOptions struct.
    //! \exception std::runtime_error when command line argument parsing fails.
    ProgramOptions(int argc, char** argv);

    //! `-c`: \c true if the JSON should be compacted instead of pretty printed
    bool compact = false;
    //! `-d`: \c true if you want debug output
    bool debug = false;
    //! `-h`: \c true if the program should exit with its usage info.
    bool help = false;
    //! `-v`: \c true if the program should exit with its version info.
    bool version = false;

    //! `-o`: the output format, default: "json"
    std::string_view output_format = "json";

    //! A list of Ruby expressions to evaluate in the given order.
    std::vector<std::string_view> expressions;
};

ProgramOptions::ProgramOptions(int argc, char** argv)
{
    if (argc < 1)
    {
        throw std::runtime_error("Really?");
    }

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
                case 'c':
                    compact = true;
                    break;
                case 'd':
                    debug = true;
                    break;
                case 'o':
                {
                    if (argit + 1 != arg.end()) // check if this is the last flag in the sequence
                    {
                        throw std::runtime_error("-o needs to be the last flag");
                    }
                    if (it + 1 == args.end()) // ensure there is one more parameter coming next
                    {
                        throw std::runtime_error("-o needs an extra parameter");
                    }

                    it = args.erase(it); // remove the current arg from the list as we already processed it
                    output_format = *it;
                    continue;
                }
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

//! \brief Print the version to \a stream.
//! \param stream The output stream to print the version info to.
void print_version(std::ostream& stream = std::cout)
{
    stream << "rq " << PROJECT_VERSION << " (mruby " << MRUBY_VERSION << ")" << std::endl;
}

//! \brief Print the application's usage to \a stream.
//! \param stream The output stream to print the usage to.
void print_usage(std::ostream& stream = std::cout)
{
    stream << R"(Usage: rq [options] [--] [EXPRESSION...]
  -c              compact the JSON instead of pretty printing it
  -d              extra debug output
  -o FORMAT       print the result in FORMAT
                  supported formats: json (default), ruby, plain
  -v              print the version number
  -h              show this message)" << std::endl;
}

class NullBuffer : public std::streambuf
{
public:
    int overflow(int c) { return c; }
};

//! \brief Main entry point.
//! \param argc Number of arguments.
//! \param argv List of arguments.
int main(int argc, char** argv)
{
    // set up null buffer for debug logging
    NullBuffer null_buffer;
    std::ostream null_stream(&null_buffer);

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

        if (!opts.debug)
        {
            Debug = &null_stream;
        }

        MRuby::Interpreter rb;

        *Debug << "loading Rq class" << std::endl;
        rb.load_irep(mrbc_rq);
        MRuby::Class* rq_class = rb.class_get("Rq");
        rq_class->ivar_set("@compact", mrb_bool_value(opts.compact));
        rq_class->ivar_set("@debug", mrb_bool_value(opts.debug));
        rq_class->ivar_set("@output_format", opts.output_format);
        rb.load_irep(mrbc_ruby_formatter);

        *Debug << "reading from stdin" << std::endl;
        if (!rb.eval("item = JSON.parse(STDIN.read)"))
        {
            std::cerr << "rq: read from stdin failed:" << std::endl;
            rb.print_error();

            return EXIT_FAILURE;
        }

        *Debug << "running " << opts.expressions.size() << " expressions" << std::endl;
        for (const auto& expr : opts.expressions)
        {
            auto wrapped_expr = ExpressionWrapper::wrap(expr);
            *Debug << "----> " << wrapped_expr << std::endl;
            if (!rb.eval(wrapped_expr))
            {
                std::cerr << "rq: expression " << std::quoted(expr, '\'') << " failed to run:" << std::endl;
                rb.print_error();

                return EXIT_FAILURE;
            }
        }

        *Debug << "printing item" << std::endl;
        if (!rb.eval("Rq.print_result(item)"))
        {
            std::cerr << "rq: printing item failed" << std::endl;
            rb.print_error();

            return EXIT_FAILURE;
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
