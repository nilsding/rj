# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require 'open3'

class RjRunner
  RJ_BIN = ENV["RJ_BIN"] || File.expand_path("../../bin/rj", __dir__)

  attr_reader :argv, :stdin, :stdout, :stderr, :status

  def initialize(argv: [], stdin: nil)
    @argv = argv
    @stdin = stdin
  end

  def run
    @stdout, @stderr, process = Open3.capture3(*[RJ_BIN, *argv], stdin_data: stdin)
    @status = process.exitstatus
  end
end
