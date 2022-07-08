MRuby::Build.new do |conf|
  conf.toolchain

  # include the default gems
  conf.gembox 'default'

  # C compiler settings
  #conf.enable_debug
  conf.enable_cxx_abi
  conf.enable_cxx_exception
  #conf.enable_test
end
