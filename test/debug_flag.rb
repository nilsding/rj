require_relative './support/rq_test'

class DebugFlag < RqTest
  rq_test! :start,
      argv: [
        '-d',
        '.first',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
        ],
        stdin:  :basic_array,
        stdout: :test_usage_from_readme_two_expressions,
        stderr: :from_fixture

  rq_test! :middle,
      argv: [
        '.first',
        '-d',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
        ],
        stdin:  :basic_array,
        stdout: :test_usage_from_readme_two_expressions,
        stderr: :test_debug_flag_start

  rq_test! :end,
      argv: [
        '.first',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
        '-d',
        ],
        stdin:  :basic_array,
        stdout: :test_usage_from_readme_two_expressions,
        stderr: :test_debug_flag_start

  rq_test! :after_two_dashes,
      argv: [
        '.first',
        '--',
        '-d',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
        ],
        stdin:  :basic_array,
        status: 1,
        stderr: :from_fixture
end
