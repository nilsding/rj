require_relative './support/rq_test'

class OutputFormat < RqTest
  # BEGIN format tests =======================================================
  rq_test! :ruby,
      argv: [
        '-o',
        'ruby',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rq_test! :ruby_compact,
      argv: [
        '-c',
        '-o',
        'ruby',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  # the trashpandas object (from /r/trashpandas/top.json) has some interesting
  # attributes like empty arrays/hashes, arrays of hashes, and `null`s that
  # the ruby formatter should handle nicely
  rq_test! :ruby_trashpandas,
      argv: [
        '-o',
        'ruby',
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture
  # END format tests =========================================================

  # BEGIN flag handling ======================================================
  rq_test! :no_arg,
      argv: [
        '-o',
      ],
      status: 1,
      stderr: :from_fixture,
      msg: '-o needs an argument'

  rq_test! :combined_flag_at_start,
      argv: [
        '-od',
        'ruby'
      ],
      status: 1,
      stderr: :from_fixture,
      msg: '-o needs to be the last one'

  rq_test! :combined_flag_at_end,
      argv: [
        '-do',
        'ruby',
      ],
      stdin:  :basic_array,
      stdout: :test_output_format_ruby,
      stderr: :from_fixture

  rq_test! :combined_arg,
      argv: [
        '-oruby',
      ],
      status: 1,
      stderr: :test_output_format_combined_flag_at_start,
      msg: 'format parameter needs to be its own argument'
  # END flag handling ========================================================
end
