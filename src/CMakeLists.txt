configure_file(config.h.in config.h)

add_subdirectory(mruby++)

set(PROJECT_SOURCES
  expressionwrapper.cpp
  main.cpp
)

add_mrbc(RUBY_SOURCES
  rq.rb
)

add_executable(rq
  ${PROJECT_SOURCES}
  ${RUBY_SOURCES}
)

add_dependencies(rq mruby)

target_link_libraries(rq PRIVATE
  mruby++
)

install(
  TARGETS rq
  RUNTIME DESTINATION bin
)

# add each test individually
file(GLOB test_files ${CMAKE_SOURCE_DIR}/test/*.rb)
foreach(test_f ${test_files})
  get_filename_component(test_name ${test_f} NAME_WE)
  # ignore rq_test test suite, as it just tests everything
  if (${test_name} STREQUAL rq_test)
    continue()
  endif()

  add_test(
    NAME ${test_name}
    COMMAND ruby ${test_f}
  )
  set_property(
    TEST ${test_name}
    PROPERTY ENVIRONMENT RQ_BIN=$<TARGET_FILE:rq>
  )
endforeach()
