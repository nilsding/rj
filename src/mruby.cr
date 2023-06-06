# This file is part of rj
#
# SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require "../vendor/mruby/consts.cr"

module MRuby
  macro precompile!(const_name, filename)
    {% puts "Generating mruby bytecode #{filename}" %}
    {{ const_name }} = [ {{ system("#{__DIR__}/../vendor/mruby/bin/mrbc -B #{const_name.stringify.downcase} -o - #{filename}").stringify.split("{")[1].split("}")[0].id }} ] of UInt8
  end
end

require "./mruby/class"
require "./mruby/interpreter"
