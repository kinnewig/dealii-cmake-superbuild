macro(build_scalapack)
  set(oneValueArgs VERSION MD5 MIRROR_NAME)
  cmake_parse_arguments(BUILD_SCALAPACK "" "${oneValueArgs}" "" ${ARGN})

  set(BUILD_SCALAPACK_C_FLAGS "-g -fPIC -O3")
  set(BUILD_SCALAPACK_F_FLAGS "-fallow-argument-mismatch")

  # Assamble the Download URL
  set(TMP_NAME "v${BUILD_SCALAPACK_VERSION}")
  set(TMP_PACKING ".tar.gz")
  #set(TMP_URL "https://github.com/scivision/scalapack/archive/refs/tags/")
  set(TMP_URL "https://github.com/kinnewig/scalapack/archive/refs/tags/")
  set(BUILD_SCALAPACK_URL "${TMP_URL}${TMP_NAME}${TMP_PACKING}")
  
  # Assamble the Mirror (if provided)
  if(DEFINED MIRROR) 
    # overwrite the default packing, in case that the mirror uses a different format
    if (NOT DEFINED MIRROR_PACKING)
      set(TMP_MIRROR_PACKING ${TMP_PACKING})
    else()
      set(TMP_MIRROR_PACKING ${MIRROR_PACKING})
    endif()
    
    if (DEFINED BUILD_SCALAPACK_MIRROR_NAME)
      set(TMP_NAME ${BUILD_SCALAPACK_MIRROR_NAME})
    endif()
  
    set(BUILD_SCALAPACK_URL "${MIRROR}${TMP_NAME}${TMP_MIRROR_PACKING} ${BUILD_SCALAPACK_URL}")
    unset(TMP_MIRROR_PACKING)
  endif()
  
  # Unset temporal variables
  unset(TMP_NAME)
  unset(TMP_PACKING)
  unset(TMP_URL)

  if ( TRILINOS_WITH_COMPLEX )
    list(APPEND SCALAPACK_CONFOPTS -D BUILD_COMPLEX=ON -D BUILD_COMPLEX16=ON)
    #list(APPEND SCALAPACK_CONFOPTS "-D BUILD_COMPLEX=ON")
  endif()

  # Build ScaLAPACK
  build_cmake_subproject(
    NAME ScaLAPACK
    VERSION ${BUILD_SCALAPACK_VERSION}
    URL ${BUILD_SCALAPACK_URL}
    MD5 ${BUILD_SCALAPACK_MD5}
    DOWNLOAD_ONLY ${DOWNLOAD_ONLY}
    BUILD_ARGS
      -D BUILD_SHARED_LIBS:BOOL=ON
      -D CMAKE_C_COMPILER=${CMAKE_MPI_C_COMPILER}
      -D CMAKE_Fortran_COMPILER=${CMAKE_MPI_Fortran_COMPILER}
      -D CMAKE_CXX_COMPILER=${CMAKE_MPI_CXX_COMPILER}
      -D CMAKE_C_FLAGS:STRING=${BUILD_SCALAPACK_C_FLAGS}
      -D CMAKE_Fortran_FLAGS:STRING=${BUILD_SCALAPACK_F_FLAGS}
      -D CMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
      -D BLAS_LIBRARY_DIRS:STRING=${BLAS_DIR}
      -D LAPACK_LIBRARY_DIRS:STRING=${BLAS_DIR}
      ${SCALAPACK_CONFOPTS}
    DEPENDS_ON ${SCALAPACK_DEPENDENCIES}
  )
  
  list(APPEND CMAKE_PREFIX_PATH "${ScaLAPACK_DIR}")
  
  # Configure deal.II to use ScaLAPACK
  list(APPEND DEALII_CONFOPTS "-D DEAL_II_WITH_SCALAPACK:BOOL=ON")
  list(APPEND DEALII_CONFOPTS "-D SCALAPACK_DIR=${ScaLAPACK_DIR}")

  # Configure Trilinos to use ScaLAPACK
  list(APPEND TRILINOS_DEPENDENCIES "ScaLAPACK")
  list(APPEND TRILINOS_CONFOPTS "-D TPL_ENABLE_SCALAPACK:BOOL=ON")
  list(APPEND TRILINOS_CONFOPTS "-D SCALAPACK_LIBRARY_DIRS:PATH=${ScaLAPACK_DIR}/lib64")

  # Configure MUMPS to use ScaLAPACK
  list(APPEND MUMPS_DEPENDENCIES "ScaLAPACK")
  list(APPEND MUMPS_CONFOPTS "-D USER_PROVIDED_SCALAPACK_DIR:PATH=${ScaLAPACK_DIR}")
endmacro()
