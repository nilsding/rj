# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require_relative './support/rj_test'

class OutputFormat < RjTest
  # BEGIN format tests =======================================================
  rj_test! :ruby,
      argv: [
        '-o',
        'ruby',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rj_test! :ruby_compact,
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
  rj_test! :ruby_trashpandas,
      argv: [
        '-o',
        'ruby',
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture
  # END format tests =========================================================

  # BEGIN flag handling ======================================================
  rj_test! :no_arg,
      argv: [
        '-o',
      ],
      status: 1,
      stderr: :from_fixture,
      msg: '-o needs an argument'

  rj_test! :combined_flag_at_start,
      argv: [
        '-od',
        'ruby'
      ],
      status: 1,
      stderr: :from_fixture,
      msg: '-o needs to be the last one'

  rj_test! :combined_flag_at_end,
      argv: [
        '-do',
        'ruby',
      ],
      stdin:  :basic_array,
      stdout: :test_output_format_ruby,
      stderr: :from_fixture

  rj_test! :combined_arg,
      argv: [
        '-oruby',
      ],
      status: 1,
      stderr: :test_output_format_combined_flag_at_start,
      msg: 'format parameter needs to be its own argument'
  # END flag handling ========================================================

  # BEGIN flag handling for '-r' =============================================
  rj_test! :r_flag,
      argv: [
        '-r',
      ],
      stdin: %("plain text string"),
      stdout: %(plain text string\n)

  rj_test! :r_flag_o_json_afterwards,
      argv: [
        '-r',
        '-o',
        'json',
      ],
      stdin: %("plain text string"),
      stdout: %("plain text string"\n),
      msg: 'CLI flags are evaluated left to right, lastmost option wins'

  rj_test! :r_flag_o_json_afterwards_then_r_again,
      argv: [
        '-r',
        '-o',
        'json',
        '-r',
      ],
      stdin: %("plain text string"),
      stdout: %(plain text string\n),
      msg: 'CLI flags are evaluated left to right, lastmost option wins'

  # END flag handling for '-r' ===============================================
end
