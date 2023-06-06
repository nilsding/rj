# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

MRuby::Build.new do |conf|
  conf.toolchain

  # include the default gems
  conf.gembox 'default'
  conf.gem git: 'https://github.com/iij/mruby-iijson.git', checksum_hash: 'c5e730c30090d3cddae258f57ab9508edb3e9fce'

  # TODO: i keep running into weird issues when having presym enabled on darwin arm64, need to figure out why
  conf.disable_presym
end
