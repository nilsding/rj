require_relative './support/rq_test'

class Compact < RqTest
  rq_test! :option,
      argv: [
        '-c',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture
end
