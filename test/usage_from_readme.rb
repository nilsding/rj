require_relative './support/rq_test'

class UsageFromReadme < RqTest
  rq_test! :first_element,
      argv: [
        '.first',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rq_test! :third_element,
      argv: [
        '[2]',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rq_test! :specific_fields,
      argv: [
        '.first.slice("foo", "bar")',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rq_test! :two_expressions,
      argv: [
        '.first',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rq_test! :map,
      argv: [
        '.map { |item| { one: item["foo"], two: item.dig("bar", "name") } }'
      ],
      stdin:  :basic_array,
      stdout: :from_fixture
end
