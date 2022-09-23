# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require_relative './support/rj_test'

class UsageFromReadme < RjTest
  rj_test! :first_element,
      argv: [
        '.first',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rj_test! :third_element,
      argv: [
        '[2]',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rj_test! :specific_fields,
      argv: [
        '.first.slice("foo", "bar")',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rj_test! :two_expressions,
      argv: [
        '.first',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
        ],
        stdin:  :basic_array,
        stdout: :from_fixture

  rj_test! :map,
      argv: [
        '.map { |item| { one: item["foo"], two: item.dig("bar", "name") } }'
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rj_test! :map_method_syntax,
      argv: [
        '.map { |item| { one: item.foo, two: item.bar.name } }',
      ],
      stdin:  :basic_array,
      stdout: :test_usage_from_readme_map
end
