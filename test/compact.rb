require_relative './support/rj_test'

class Compact < RjTest
  rj_test! :option,
      argv: [
        '-c',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture
end
