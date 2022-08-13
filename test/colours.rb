require_relative "./support/rj_test"

# Tests colour output.
# by default running rj from the test suite does not enable coloured output as
# its not outputting to a TTY -- so it needs to be forced
class Colours < RjTest
  rj_test! :no_option,
      argv: [],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture

  rj_test! :force_colour,
      argv: [
        "-C",
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture

  rj_test! :force_monochrome,
      argv: [
        "-M",
      ],
      stdin:  :reddit_trashpandas,
      stdout: :test_colours_no_option

  rj_test! :force_monochrome_and_colour,
      argv: [
        "-M",
        "-C",
      ],
      stdin:  :reddit_trashpandas,
      stdout: :test_colours_force_colour,
      msg: "-C is last and takes precedence"

  rj_test! :compact,
      argv: [
        "-C",
        "-c",
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture

  rj_test! :ruby,
      argv: [
        "-C",
        "-o",
        "ruby",
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture

  rj_test! :ruby_compact,
      argv: [
        "-C",
        "-c",
        "-o",
        "ruby",
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture

  rj_test! :ruby_symbols_and_other_classes,
      argv: [
        "-Co",
        "ruby",
        '{:symbol => true, "class" => String.class, method: Rj.method(:__debug_info)}'
      ],
      stdin:  "{}",
      stdout: :from_fixture

  rj_test! :ruby_symbols_and_other_classes_compact,
      argv: [
        "-Cco",
        "ruby",
        '{:symbol => true, "class" => String.class, method: Rj.method(:__debug_info)}'
      ],
      stdin:  "{}",
      stdout: :from_fixture
end
