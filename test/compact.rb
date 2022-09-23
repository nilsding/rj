# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require_relative './support/rj_test'

class Compact < RjTest
  rj_test! :option,
      argv: [
        '-c',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture
end
