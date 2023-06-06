# frozen_string_literal: true
#
# This file is part of rj
#
# SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
# SPDX-License-Identifier: GPL-3.0-or-later

require "digest/sha2"
require "erb"
require "rake/clean"

task :default => [:build]

namespace :mruby do
  MRUBY_VERSION = "3.2.0"
  MRUBY_SOURCE_URL = "https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz"
  MRUBY_EXPECTED_SHASUM = "bb46fa0eda6507cabe775e3f9cceec6da64d5a96c20e704e7ada94f5b4906989553c363cfd85789c4adcb030a6cfd36b8a99d8247f32687c913bbe06edb9bbca"

  MRUBY_DIR = File.expand_path("./vendor/mruby", __dir__)
  MRUBY_SOURCE_TAR_PATH = File.join(MRUBY_DIR, "mruby-#{MRUBY_VERSION}.tar.gz")
  MRUBY_SOURCE_DIR = File.join(MRUBY_DIR, "mruby-#{MRUBY_VERSION}")
  MRUBY_BUILD_DIR = File.join(MRUBY_DIR, "build")
  MRUBY_BIN_DIR = File.join(MRUBY_DIR, "bin")
  MRUBY_CONSTS_PATH = File.join(MRUBY_DIR, "consts.cr")
  CLEAN.include(MRUBY_DIR)

  directory MRUBY_DIR
  directory MRUBY_BUILD_DIR
  directory MRUBY_BIN_DIR

  task :prepare => [MRUBY_DIR, MRUBY_BUILD_DIR, MRUBY_BIN_DIR]

  file MRUBY_SOURCE_TAR_PATH => [:prepare] do
    # already downloaded
    next if File.exist?(MRUBY_SOURCE_TAR_PATH)

    puts "===> Downloading #{MRUBY_SOURCE_URL} using cURL"

    sh "curl", "-L", "-o", MRUBY_SOURCE_TAR_PATH, MRUBY_SOURCE_URL
    next if Digest::SHA512.file(MRUBY_SOURCE_TAR_PATH).hexdigest == MRUBY_EXPECTED_SHASUM

    rm_rf MRUBY_SOURCE_TAR_PATH
    raise "sha512 sum of mruby source does not match"
  end

  task :fetch => [MRUBY_SOURCE_TAR_PATH]

  task :unpack => [:fetch] do
    # already unpacked
    next if Dir.exist?(MRUBY_SOURCE_DIR)

    puts "===> Unpacking #{File.basename(MRUBY_SOURCE_TAR_PATH)}"
    Dir.chdir MRUBY_DIR do
      sh "tar", "xf", MRUBY_SOURCE_TAR_PATH
    end
  end

  task :build => [:unpack] do
    puts "===> Building #{File.basename(MRUBY_SOURCE_DIR)}"
    Dir.chdir MRUBY_SOURCE_DIR do
      args = {
        mruby_config: File.expand_path("mruby_config.rb", __dir__),
        mruby_build_dir: MRUBY_BUILD_DIR,
        install_dir: MRUBY_BIN_DIR,
      }.map { [_1.upcase, _2].join("=") }

      sh "rake", *args
    end
  end

  task :gen_consts => [:build] do
    puts "===> Generating consts file"

    consts_of_interest = {
      strings: %w[
        MRUBY_COPYRIGHT
        MRUBY_DESCRIPTION
        MRUBY_VERSION
      ],
      ints: %w[
        MRB_METHOD_CACHE_SIZE

        WORDBOX_SYMBOL_FLAG
        WORDBOX_SYMBOL_SHIFT
      ],
      defines: %w[
        MRB_NAN_BOXING
        MRB_WORD_BOXING

        MRB_BYTECODE_DECODE_OPTION
        MRB_FIXED_STATE_ATEXIT_STACK
        MRB_GC_FIXED_ARENA
        MRB_NO_FLOAT
        MRB_NO_METHOD_CACHE
        MRB_NO_PRESYM
        MRB_USE_ALL_SYMBOLS
        MRB_USE_DEBUG_HOOK
        MRB_USE_METHOD_T_STRUCT
      ]
    }
    consts_source_path = File.join(MRUBY_DIR, "gen_consts.c")
    consts_bin_path = File.join(MRUBY_DIR, "gen_consts")
    consts_source_contents = ERB.new(<<~C).result_with_hash(consts_of_interest)
      /*
       * This file is part of rj
       *
       * SPDX-FileCopyrightText: 2023 Georg Gadinger <nilsding@nilsding.org>
       * SPDX-License-Identifier: GPL-3.0-or-later
       */

      #include <stdio.h>
      #include <mruby.h>

      static void print_double_quote(const char* c)
      {
        putchar('"');
        while (*c)
        {
          if (*c == '"') putchar('\\\\');
          putchar(*c);
          if (*c == '"') putchar('\\\\');
          c++;
        }
        putchar('"');
      }

      int main(void)
      {
        puts("module MRuby");

        <% strings.each do |const_name| %>
        printf("  <%= const_name %> = ");
        print_double_quote(<%= const_name %>);
        putchar('\\n');
        <% end %>

        <% ints.each do |const_name| %>
        printf("  <%= const_name %> = %d\\n", <%= const_name %>);
        <% end %>

        puts("  module Defines");
        <% defines.each do |const_name| %>
        printf("    <%= const_name %> = ");
        puts(
        #ifdef <%= const_name %>
          "true"
        #else
          "false"
        #endif
        );
        <% end %>
        puts("  end");

        puts("end");
        return 0;
      }
    C
    File.open(consts_source_path, "w") { _1.puts consts_source_contents }

    cflags = `#{File.join(MRUBY_BIN_DIR, "mruby-config")} --cflags`.strip
    cc = ENV.fetch("CC", "cc")
    sh "#{cc} #{cflags} -o #{consts_bin_path} #{consts_source_path}"

    sh "#{consts_bin_path} > #{MRUBY_CONSTS_PATH.inspect}"
  end

  task :build_all => [:build, :gen_consts]
end

task :build => [:"mruby:build_all"] do
  puts "===> Building rj"
  sh "shards", "build"
end

task :build_release => [:"mruby:build_all"] do
  puts "===> Building rj for release"
  sh "shards", "build", "--release"
end
