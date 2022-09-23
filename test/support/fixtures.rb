# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

# Hash containing all JSON fixtures that can be passed to rj's stdin during testing
JsonFixtures = Dir[File.expand_path("../fixtures/*.json", __dir__)].map do |fn|
  [File.basename(fn, ".json").to_sym, File.read(fn)]
end.to_h

# Hash containing the expected stdout
StdoutFixtures = Dir[File.expand_path("../fixtures/*_stdout.txt", __dir__)].map do |fn|
  [File.basename(fn, "_stdout.txt").to_sym, File.read(fn)]
end.to_h

# Hash containing the expected stderr
StderrFixtures = Dir[File.expand_path("../fixtures/*_stderr.txt", __dir__)].map do |fn|
  [File.basename(fn, "_stderr.txt").to_sym, File.read(fn)]
end.to_h
