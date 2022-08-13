configure_file(config.h.in config.h)

add_subdirectory(mruby++)

set(PROJECT_SOURCES
  expressionwrapper.cpp
  main.cpp
)

add_mrbc(RUBY_SOURCES
  colours.rb
  json_ext.rb
  method_accessor.rb
  rj.rb
  ruby_formatter.rb
)

add_executable(rj
  ${PROJECT_SOURCES}
  ${RUBY_SOURCES}
)

add_dependencies(rj mruby)

target_link_libraries(rj PRIVATE
  mruby++
)

install(
  TARGETS rj
  RUNTIME DESTINATION bin
)

# add each test individually
file(GLOB test_files ${CMAKE_SOURCE_DIR}/test/*.rb)
foreach(test_f ${test_files})
  get_filename_component(test_name ${test_f} NAME_WE)
  # ignore rj_test test suite, as it just tests everything
  if (${test_name} STREQUAL rj_test)
    continue()
  endif()

  add_test(
    NAME ${test_name}
    COMMAND ruby ${test_f}
  )
  set_property(
    TEST ${test_name}
    PROPERTY ENVIRONMENT RJ_BIN=$<TARGET_FILE:rj>
  )
endforeach()
