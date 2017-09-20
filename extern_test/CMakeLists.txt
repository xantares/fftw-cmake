cmake_minimum_required (VERSION 2.8)

if (NOT DEFINED CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
endif ()

project (extern_test)

find_package (FFTW3 NO_MODULE)
find_package (FFTW3f NO_MODULE)

add_definitions (-DFFTW_DLL)
add_definitions (-D_USE_MATH_DEFINES)

enable_testing ()

if (FFTW3_FOUND)
  include_directories (${FFTW3_INCLUDE_DIRS})
  add_executable (t_fftw3 t_fftw3.cpp)
  link_directories (${FFTW3_LIBRARY_DIRS})
  target_link_libraries (t_fftw3 ${FFTW3_LIBRARIES})
  add_test (NAME fftw3 COMMAND t_fftw3)
  install (TARGETS t_fftw3 DESTINATION bin)
endif ()

if (FFTW3f_FOUND)
  include_directories (${FFTW3f_INCLUDE_DIRS})
  add_executable (t_fftw3f t_fftw3f.cpp)
  link_directories (${FFTW3f_LIBRARY_DIRS})
  message (STATUS "FFTW3f: ${FFTW3f_INCLUDE_DIRS} ${FFTW3f_LIBRARIES} ${FFTW3f_LIBRARY_DIRS}")
  target_link_libraries (t_fftw3f ${FFTW3f_LIBRARIES})
  add_test (NAME fftw3f COMMAND t_fftw3f)
  install (TARGETS t_fftw3f DESTINATION bin)
endif ()
