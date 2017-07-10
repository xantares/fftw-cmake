cmake_minimum_required(VERSION 2.8)

if (NOT DEFINED CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
endif ()

project (extern_test)

set (CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

find_package (FFTW3)
find_package (FFTW3F)

include_directories (${FFTW3_INCLUDE_DIR})

add_definitions (-DFFTW_DLL)
add_definitions (-D_USE_MATH_DEFINES)

enable_testing ()

if (FFTW3_FOUND)
  add_executable (t_fftw3 t_fftw3.cpp)
  target_link_libraries (t_fftw3 ${FFTW3_LIBRARIES})
  add_test (NAME fftw3 COMMAND t_fftw3)
  install (TARGETS t_fftw3 DESTINATION bin)
endif ()

if (FFTW3F_FOUND)
  message(STATUS)
  add_executable (t_fftw3f t_fftw3f.cpp)
  target_link_libraries (t_fftw3f ${FFTW3F_LIBRARIES})
  add_test (NAME fftw3f COMMAND t_fftw3f)
  install (TARGETS t_fftw3f DESTINATION bin)
endif ()
