cmake_minimum_required(VERSION 3.20)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(CMakeDependentOption)
include(FeatureSummary)

# fetch mruby from source
include(ExternalProject)
ExternalProject_Add(
  mruby
  URL https://github.com/mruby/mruby/archive/3.1.0.tar.gz
  URL_HASH SHA512=b3699587689709b7411105ef468c28a6d89941dea356e6b3272b6ba1f69dc2d59e9c1ebc56c55208adc8b2ba878e21c8961ddd4603781748070fc78b6c2bbdb2
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    rake MRUBY_CONFIG=${CMAKE_CURRENT_SOURCE_DIR}/mruby_config.rb INSTALL_DIR=<INSTALL_DIR> MRUBY_BUILD_DIR=<INSTALL_DIR>/build
  BUILD_IN_SOURCE true
  INSTALL_COMMAND
    ""
)
ExternalProject_Get_Property(mruby SOURCE_DIR INSTALL_DIR)
ExternalProject_Get_Property(mruby INSTALL_DIR)
set(MRUBY_SOURCE_DIR ${SOURCE_DIR})
set(MRUBY_INSTALL_DIR ${INSTALL_DIR})
set(MRUBY_BUILD_DIR ${MRUBY_INSTALL_DIR}/build/host)
set(MRUBY_LIBS
  ${MRUBY_BUILD_DIR}/lib/libmruby.a
)
set(MRUBY_INCLUDE_DIRS
  ${MRUBY_SOURCE_DIR}/include
  ${MRUBY_BUILD_DIR}/include
)
include_directories(${MRUBY_INCLUDE_DIRS})
add_compile_definitions(
  MRB_USE_CXX_ABI
  MRB_USE_CXX_EXCEPTION
)
# not using `find_program` for this one as mrbc might not yet exist
set(MRBC_EXECUTABLE "${MRUBY_INSTALL_DIR}/mrbc")

# precompiles .rb files using the freshly built mrbc
function(add_mrbc out_var)
  set(result)
  file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mrbc")
  foreach(in_f ${ARGN})
    get_filename_component(basename ${in_f} NAME_WE)
    set(out_f "${CMAKE_CURRENT_BINARY_DIR}/mrbc/${in_f}.cpp")
    set(in_f "${CMAKE_CURRENT_SOURCE_DIR}/${in_f}")
    file(RELATIVE_PATH out_f_comment ${CMAKE_BINARY_DIR} ${out_f})
    add_custom_command(OUTPUT ${out_f}
      COMMAND ${MRBC_EXECUTABLE} -B mrbc_${basename} -o ${out_f} ${in_f}
      DEPENDS mruby ${in_f}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Generating mruby bytecode ${out_f_comment}"
      VERBATIM
    )
    list(APPEND result ${out_f})
  endforeach()
  set(${out_var} "${result}" PARENT_SCOPE)
endfunction()

# configure the rest of our project
project(rj VERSION 0.4.0 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

enable_testing()

add_subdirectory(src)

feature_summary(
    FATAL_ON_MISSING_REQUIRED_PACKAGES
    WHAT ALL
)
