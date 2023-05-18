# This file is part of rj
#
# SPDX-FileCopyrightText: 2022 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

MRuby::Build.new do |conf|
  conf.toolchain

  # include the default gems
  conf.gembox 'default'
  conf.gem git: 'https://github.com/iij/mruby-iijson.git', checksum_hash: 'c5e730c30090d3cddae258f57ab9508edb3e9fce'

  # C compiler settings
  conf.enable_cxx_abi
  conf.enable_cxx_exception

  if ENV.key?("UNIVERSAL_BUILD")
    conf.cc.flags << %w(-arch arm64 -arch x86_64)
    conf.cxx.flags << %w(-arch arm64 -arch x86_64)
    conf.linker.flags << %w(-arch arm64 -arch x86_64)
  end
end

return unless ENV.key?("UNIVERSAL_BUILD")

# Hack to fix the preprocessor command in universal builds:

class MRuby::Command::Compiler
  # https://github.com/mruby/mruby/blob/3.2.0/lib/mruby/build/command.rb#L83-L96
  def run(outfile, infile, _defines=[], _include_paths=[], _flags=[])
    mkdir_p File.dirname(outfile)
    flags = all_flags(_defines, _include_paths, _flags)
    if object_ext?(outfile)
      label = @label
      opts = compile_options
    else
      label = "CPP"
      opts = preprocess_options
      flags << " -DMRB_PRESYM_SCANNING"
      # need to remove the `-arch` flags from the preprocessor command here as clang errors out otherwise:
      # clang: error: cannot use 'c++-cpp-output' output with multiple -arch options
      flags = flags.sub('-arch arm64 -arch x86_64', '')
    end
    _pp label, infile.relative_path, outfile.relative_path
    _run opts, flags: flags, infile: filename(infile), outfile: filename(outfile)
  end
end
