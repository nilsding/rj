require_relative './support/rq_test'

class Internals < RqTest
  rq_test! :noflags,
      argv: [
        '--',
        'Rq.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture

  rq_test! :compact,
      argv: [
        '-c',
        '--',
        'Rq.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture

  rq_test! :debug,
      argv: [
        '-d',
        '--',
        'Rq.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture,
      stderr: :from_fixture

  rq_test! :compact_debug,
      argv: [
        '-c',
        '-d',
        '--',
        'Rq.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture,
      stderr: :test_internals_debug

  rq_test! :compact_debug_combined,
      argv: [
        '-cd',
        '--',
        'Rq.__debug_info',
      ],
      stdin:  "{}",
      stdout: :test_internals_compact_debug,
      stderr: :test_internals_debug

end
