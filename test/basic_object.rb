require_relative './support/rj_test'

class BasicObjectTest < RjTest
  rj_test! :noargs,
      stdin:  :basic_object,
      stdout: :from_fixture

  rj_test! :languages,
      argv: [
        '["languages"]',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rj_test! :languages_select,
      argv: [
        '["languages"]',
        '.select { |lang| %w[C++ Ruby].include?(lang) }'
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rj_test! :return_string,
      argv: [
        '["location"]',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rj_test! :return_object,
      argv: [
        '{ location: item["location"], short_location: item["location"].upcase[0..1] }',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rj_test! :error,
      argv: [
        '.unknown_method',
      ],
      stdin:  :basic_object,
      status: 1,
      stderr: :from_fixture,
      stdout: :from_fixture
end
