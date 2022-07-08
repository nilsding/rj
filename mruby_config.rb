MRuby::Build.new do |conf|
  conf.toolchain

  # include the default gems
  conf.gembox 'default'
  conf.gem git: 'https://github.com/iij/mruby-iijson.git', checksum_hash: 'c5e730c30090d3cddae258f57ab9508edb3e9fce'

  # C compiler settings
  conf.enable_cxx_abi
  conf.enable_cxx_exception
end
