cmake_minimum_required (VERSION 3.0)

if (NOT DEFINED CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
endif ()

project (fftw)

if (POLICY CMP0042)
  cmake_policy (SET CMP0042 NEW)
endif ()

option (BUILD_SHARED_LIBS "Build shared libraries" ON)

option (ENABLE_OPENMP "Use OpenMP for multithreading" OFF)
option (ENABLE_THREADS "Use pthread for multithreading" OFF)
option (WITH_COMBINED_THREADS "Merge thread library" OFF)

option (ENABLE_FLOAT "single-precision" OFF)
option (ENABLE_LONG_DOUBLE "long-double precision" OFF)
option (ENABLE_QUAD_PRECISION "quadruple-precision" OFF)

option (ENABLE_SSE2 "Compile with SSE2 instruction set support" OFF)
option (ENABLE_AVX "Compile with AVX instruction set support" OFF)

set (LIBRARY_PATH lib${LIB_SUFFIX})


include (CheckIncludeFile)
check_include_file (alloca.h         HAVE_ALLOCA_H)
check_include_file (altivec.h        HAVE_ALTIVEC_H)
check_include_file (c_asm.h          HAVE_C_ASM_H)
check_include_file (dlfcn.h          HAVE_DLFCN_H)
check_include_file (intrinsics.h     HAVE_INTRINSICS_H)
check_include_file (inttypes.h       HAVE_INTTYPES_H)
check_include_file (libintl.h        HAVE_LIBINTL_H)
check_include_file (limits.h         HAVE_LIMITS_H)
check_include_file (mach/mach_time.h HAVE_MACH_MACH_TIME_H)
check_include_file (malloc.h         HAVE_MALLOC_H)
check_include_file (memory.h         HAVE_MEMORY_H)
check_include_file (stddef.h         HAVE_STDDEF_H)
check_include_file (stdint.h         HAVE_STDINT_H)
check_include_file (stdlib.h         HAVE_STDLIB_H)
check_include_file (string.h         HAVE_STRING_H)
check_include_file (strings.h        HAVE_STRINGS_H)
check_include_file (sys/types.h      HAVE_SYS_TYPES_H)
check_include_file (sys/time.h       HAVE_SYS_TIME_H)
check_include_file (sys/stat.h       HAVE_SYS_STAT_H)
check_include_file (sys/sysctl.h     HAVE_SYS_SYSCTL_H)
check_include_file (time.h           HAVE_TIME_H)
check_include_file (uintptr.h        HAVE_UINTPTR_H)
check_include_file (unistd.h         HAVE_UNISTD_H)
if (HAVE_TIME_H AND HAVE_SYS_TIME_H)
  set (TIME_WITH_SYS_TIME TRUE)
endif ()

include (CheckPrototypeDefinition) 
check_prototype_definition (drand48 "double drand48 (void)" "0" stdlib.h HAVE_DECL_DRAND48)
check_prototype_definition (srand48 "void srand48(long int seedval)" "0" stdlib.h HAVE_DECL_SRAND48)
check_prototype_definition (cosl "long double cosl( long double arg )" "0" math.h HAVE_DECL_COSL)
check_prototype_definition (sinl "long double sinl( long double arg )" "0" math.h HAVE_DECL_SINL)
check_prototype_definition (memalign "void *memalign(size_t alignment, size_t size)" "0" malloc.h HAVE_DECL_MEMALIGN)
check_prototype_definition (posix_memalign "int posix_memalign(void **memptr, size_t alignment, size_t size)" "0" stdlib.h HAVE_DECL_POSIX_MEMALIGN)

include (CheckSymbolExists)
check_symbol_exists (clock_gettime sys/time.h HAVE_CLOCK_GETTIME)
check_symbol_exists (gettimeofday sys/time.h HAVE_GETTIMEOFDAY)
check_symbol_exists (drand48 stdlib.h HAVE_DRAND48)
check_symbol_exists (srand48 stdlib.h HAVE_SRAND48)
check_symbol_exists (memalign malloc.h HAVE_MEMALIGN)
check_symbol_exists (posix_memalign stdlib.h HAVE_POSIX_MEMALIGN)
check_symbol_exists (mach_absolute_time mach/mach_time.h HAVE_MACH_ABSOLUTE_TIME)
check_symbol_exists (alloca alloca.h HAVE_ALLOCA)
check_symbol_exists (isnan math.h HAVE_ISNAN)
check_symbol_exists (snprintf stdio.h HAVE_SNPRINTF)

if (UNIX)
  set (HAVE_LIBM TRUE)
endif ()


find_package (Threads)
if (Threads_FOUND)
  if(CMAKE_USE_PTHREADS_INIT)
    set (USING_POSIX_THREADS 1)
  endif ()
  set (HAVE_THREADS TRUE)
endif ()

if (ENABLE_OPENMP)
  find_package (OpenMP)
endif ()
if (OPENMP_FOUND)
  set (HAVE_OPENMP TRUE)
endif ()

include (CheckCCompilerFlag)

if (ENABLE_SSE2)
  check_c_compiler_flag (-msse2 MSSE2)
  set (HAVE_SSE2 TRUE)
endif ()

if (ENABLE_AVX)
  check_c_compiler_flag (-avx AVX)
  set (HAVE_AVX TRUE)
endif ()

if (ENABLE_SSE2 OR ENABLE_AVX)
  set (HAVE_SIMD TRUE)
endif ()
file(GLOB           fftw_api_SOURCE                 api/*.c             api/*.h)
file(GLOB           fftw_dft_SOURCE                 dft/*.c             dft/*.h)
file(GLOB           fftw_dft_scalar_SOURCE          dft/scalar/*.c      dft/scalar/*.h)
file(GLOB           fftw_dft_scalar_codelets_SOURCE dft/scalar/codelets/*.c     dft/scalar/codelets/*.h)
file(GLOB           fftw_dft_simd_SOURCE            dft/simd/*.c        dft/simd/*.h)

file(GLOB           fftw_dft_simd_sse2_SOURCE       dft/simd/sse2/*.c   dft/simd/sse2/*.h)
file(GLOB           fftw_kernel_SOURCE              kernel/*.c          kernel/*.h)
file(GLOB           fftw_rdft_SOURCE                rdft/*.c            rdft/*.h)
file(GLOB           fftw_rdft_scalar_SOURCE         rdft/scalar/*.c     rdft/scalar/*.h)

file(GLOB           fftw_rdft_scalar_r2cb_SOURCE    rdft/scalar/r2cb/*.c
                                                    rdft/scalar/r2cb/*.h)
file(GLOB           fftw_rdft_scalar_r2cf_SOURCE    rdft/scalar/r2cf/*.c
                                                    rdft/scalar/r2cf/*.h)
file(GLOB           fftw_rdft_scalar_r2r_SOURCE     rdft/scalar/r2r/*.c
                                                    rdft/scalar/r2r/*.h)

file(GLOB           fftw_rdft_simd_SOURCE           rdft/simd/*.c       rdft/simd/*.h)
file(GLOB           fftw_rdft_simd_sse2_SOURCE      rdft/simd/sse2/*.c  rdft/simd/sse2/*.h)

file(GLOB           fftw_reodft_SOURCE              reodft/*.c          reodft/*.h)
file(GLOB           fftw_simd_support_SOURCE        simd-support/*.c    simd-support/*.h)
file(GLOB           fftw_libbench2_SOURCE           libbench2/*.c       libbench2/*.h)
list (REMOVE_ITEM   fftw_libbench2_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/libbench2/useropt.c)

set(SOURCEFILES
    ${fftw_api_SOURCE}
    ${fftw_dft_SOURCE}
    ${fftw_dft_scalar_SOURCE}
    ${fftw_dft_scalar_codelets_SOURCE}
    ${fftw_dft_simd_SOURCE}
    ${fftw_kernel_SOURCE}
    ${fftw_rdft_SOURCE}
    ${fftw_rdft_scalar_SOURCE}

    ${fftw_rdft_scalar_r2cb_SOURCE}
    ${fftw_rdft_scalar_r2cf_SOURCE}
    ${fftw_rdft_scalar_r2r_SOURCE}

    ${fftw_rdft_simd_SOURCE}
    ${fftw_reodft_SOURCE}
    ${fftw_simd_support_SOURCE}
    ${fftw_threads_SOURCE}
)

set(fftw_par_SOURCE
    threads/api.c
    threads/conf.c
    threads/ct.c
    threads/dft-vrank-geq1.c
    threads/f77api.c
    threads/hc2hc.c
    threads/rdft-vrank-geq1.c
    threads/vrank-geq1-rdft2.c)

set (fftw_threads_SOURCE ${fftw_par_SOURCE} threads/threads.c)
set (fftw_omp_SOURCE ${fftw_par_SOURCE} threads/openmp.c)


include_directories(
    kernel
    api
    dft
    dft/scalar
    dft/scalar/codelets # really needed?
    dft/simd
    dft/simd/sse2
    rdft
    rdft/scalar
    rdft/simd
    reodft
    simd-support
    libbench2
)

install (FILES api/fftw3.h api/fftw3.f DESTINATION include)



if (WITH_COMBINED_THREADS)
  list (APPEND SOURCEFILES ${fftw_threads_SOURCE})
endif ()


if (ENABLE_SSE2)
  list (APPEND SOURCEFILES ${fftw_dft_simd_sse2_SOURCE} ${fftw_rdft_simd_sse2_SOURCE})
endif ()

set (FFTW_VERSION 3.3.6)
configure_file (config.h.in config.h @ONLY)
include_directories (${CMAKE_CURRENT_BINARY_DIR})

set (targets fftw3)
if (ENABLE_FLOAT)
  list (APPEND targets fftw3f)
endif ()

if (ENABLE_LONG_DOUBLE)
  list (APPEND targets fftw3l)
endif ()

if (ENABLE_QUAD_PRECISION)
  list (APPEND targets fftw3q)
endif ()

if (BUILD_SHARED_LIBS)
  add_definitions (-DFFTW_DLL)
endif ()

foreach (target ${targets})

  add_library (${target} ${SOURCEFILES})
  if (MSVC)
    target_compile_definitions (${target} PRIVATE /bigobj)
  endif ()
  if (MSSE2)
    target_compile_options (${target} PRIVATE -msse2)
  endif ()
  if (AVX)
    target_compile_options (${target} PRIVATE -avx)
  endif ()
  if (HAVE_LIBM)
    target_link_libraries (${target} m)
  endif ()

  set (subtargets ${target})

  if (Threads_FOUND)
    if (WITH_COMBINED_THREADS)
      target_link_libraries (${target} ${CMAKE_THREAD_LIBS_INIT})
    else ()
      add_library (${target}_threads ${fftw_threads_SOURCE})
      target_link_libraries (${target}_threads ${target})
      target_link_libraries (${target}_threads ${CMAKE_THREAD_LIBS_INIT})
      list (APPEND subtargets ${target}_threads)
    endif ()
  endif ()

  if (OPENMP_FOUND)
    add_library (${target}_omp ${fftw_omp_SOURCE})
    target_link_libraries (${target}_omp ${target})
    target_link_libraries (${target}_omp ${CMAKE_THREAD_LIBS_INIT})
    list (APPEND subtargets ${target}_omp)
    target_compile_options (${target}_omp PRIVATE ${OpenMP_C_FLAGS})
  endif ()

  foreach(subtarget ${subtargets})
    set_target_properties (${subtarget} PROPERTIES SOVERSION 3.5.6 VERSION 3)

    if (target STREQUAL "fftw3f")
      target_compile_definitions (${subtarget} PRIVATE FFTW_SINGLE)
    endif ()
    if (target STREQUAL "fftw3l")
      target_compile_definitions (${subtarget} PRIVATE FFTW_LDOUBLE)
    endif ()
    if (target STREQUAL "fftw3q")
      target_compile_definitions (${subtarget} PRIVATE FFTW_QUAD)
    endif ()

    install (TARGETS ${subtarget}
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION ${LIBRARY_PATH}
            ARCHIVE DESTINATION ${LIBRARY_PATH})
  endforeach ()
endforeach ()


enable_testing ()

if (Threads_FOUND)
  add_executable (bench EXCLUDE_FROM_ALL ${fftw_libbench2_SOURCE} tests/bench.c tests/hook.c tests/fftw-bench.c)

  if (WITH_COMBINED_THREADS)
    target_link_libraries (bench fftw3)
  else ()
    target_link_libraries (bench fftw3_threads)
  endif ()

  add_custom_target (tests)
  add_dependencies (tests bench)

  macro (fftw_add_test problem)
    add_test (NAME ${problem} COMMAND bench -s ${problem})
  endmacro ()

  fftw_add_test (32x64)
  fftw_add_test (ib256)

endif ()
