configure_file(config.h.in config.h)

set(PROJECT_SOURCES
    expressionwrapper.cpp
    main.cpp
    mruby++.cpp
)

add_executable(rq
    ${PROJECT_SOURCES}
)

add_dependencies(rq mruby)

add_test(
  NAME rq_test
  COMMAND ruby ${CMAKE_SOURCE_DIR}/test/rq_test.rb
)
set_property(
  TEST rq_test
  PROPERTY ENVIRONMENT RQ_BIN=$<TARGET_FILE:rq>
)

target_link_libraries(rq PRIVATE
  ${MRUBY_LIBS}
)

install(
  TARGETS rq
  RUNTIME DESTINATION bin
)
