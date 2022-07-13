require_relative './support/rq_test'

class BasicObjectTest < RqTest
  rq_test! :noargs,
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :languages,
      argv: [
        '["languages"]',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :languages_select,
      argv: [
        '["languages"]',
        '.select { |lang| %w[C++ Ruby].include?(lang) }'
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :return_string,
      argv: [
        '["location"]',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :return_object,
      argv: [
        '{ location: item["location"], short_location: item["location"].upcase[0..1] }',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :error,
      argv: [
        '.unknown_method',
      ],
      stdin:  :basic_object,
      status: 1,
      stderr: :from_fixture,
      stdout: :from_fixture
end
