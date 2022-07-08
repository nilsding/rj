configure_file(config.h.in config.h)

set(PROJECT_SOURCES
    main.cpp
    mruby++.cpp
)

add_executable(rq
    ${PROJECT_SOURCES}
)

target_link_libraries(rq PRIVATE
  ${MRUBY_LIBS}
)
