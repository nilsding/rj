# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require_relative './support/rj_test'

class Internals < RjTest
  rj_test! :noflags,
      argv: [
        '--',
        'Rj.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture

  rj_test! :compact,
      argv: [
        '-c',
        '--',
        'Rj.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture

  rj_test! :debug,
      argv: [
        '-d',
        '--',
        'Rj.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture,
      stderr: :from_fixture

  rj_test! :compact_debug,
      argv: [
        '-c',
        '-d',
        '--',
        'Rj.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture,
      stderr: :test_internals_debug

  rj_test! :compact_debug_combined,
      argv: [
        '-cd',
        '--',
        'Rj.__debug_info',
      ],
      stdin:  "{}",
      stdout: :test_internals_compact_debug,
      stderr: :test_internals_debug

end
