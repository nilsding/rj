set(MRUBY++_SOURCES
  interpreter.cpp
)

add_library(mruby++ OBJECT
  ${MRUBY++_SOURCES}
)

add_dependencies(mruby++ mruby)

target_link_libraries(mruby++ PRIVATE
  ${MRUBY_LIBS}
)
