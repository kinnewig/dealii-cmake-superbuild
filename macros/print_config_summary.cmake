macro(print_config_summary)
  message(" ")
################################################################################
## OUTPUT GENERAL INFOS                                                       ##
################################################################################


################################################################################
## Output TPLs                                                                ##
################################################################################

  message("The following packages have been chosen for installation")
  if(${INSTALL_adolc}) 
    message("\tADOL-C version ${BUILD_ADOLC_VERSION}")
  endif()
  if(${INSTALL_aocl_blis}) 
    message("\tAOCL BLIS version ${BUILD_AOCL_BLIS_VERSION}")
  endif()
  if(${INSTALL_aocl_libflame}) 
    message("\tAOCL LibFLAME version ${BUILD_AOCL_LIBFLAME_VERSION}")
  endif()
  if(${INSTALL_aocl_scalapack}) 
    message("\tAOCL ScaLAPACK version ${BUILD_AOCL_SCALAPACK_VERSION}")
  endif()
  if(${INSTALL_arpack})
    message("\tARnoldi PACKage (ARPACK) version ${BUILD_ARPACK_VERSION}")
  endif()
  if(${INSTALL_assimp})
    message("\tOpen Asset Import Library (assimp) version ${BUILD_ASSIMP_VERSION} ")
  endif()
  if(${INSTALL_ginkgo})
    message("\tGinkgo version ${BUILD_GINKGO_VERSION}")
  endif()
  if(${INSTALL_gmsh})
    message("\tGmsh version ${BUILD_GMSH_VERSION}")
  endif()
  if(${INSTALL_hdf5})
    message("\tHDF5 version ${BUILD_HDF5_VERSION}")
  endif()
  if(${INSTALL_mumps})
    message("\tMUMPS version ${BUILD_MUMPS_VERSION}")
  endif()
  if(${INSTALL_libflame})
    message("\tLIBFLAME version ${BUILD_LIBFLAME_VERSION}")
  endif()
  if(${INSTALL_openblas})
    message("\tOpenBLAS version ${BUILD_OPENBLAS_VERSION}")
  endif()
  if(${INSTALL_blis})
    message("\tBLIS version ${BUILD_BLIS_VERSION}")
  endif()
  if(${INSTALL_opencascase})
    message("\tOpenCASCADE Community Edition (OCE) version ${BUILD_OPENCASCADE_VERSION}")
  endif()
  if(${INSTALL_p4est})
    message("\tp4est version ${BUILD_P4EST_VERSION}")
  endif()
  if(${INSTALL_parmetis})
    message("\tParMETIS version ${BUILD_PARMETIS_VERSION}")
  endif()
  if(${INSTALL_reference_scalapack})
    message("\tReference ScaLAPACK version ${BUILD_SCALAPACK_VERSION}")
  endif()
  if(${INSTALL_sundials})
    message("\tSUNDIALS version ${BUILD_SUNDIALS_VERSION}")
  endif()
  if(${INSTALL_superlu_dist})
    message("\tSuperLU_DIST version ${BUILD_SUPERLU_VERSION}")
  endif()
  if(${INSTALL_symengine})
    message("\tSymEngine version ${BUILD_SYMENGINE_VERSION}")
  endif()
  if(${INSTALL_trilinos})
    message("\tTrilinos version ${BUILD_TRILINOS_VERSION}")
  endif()

################################################################################
## OUTPUT DEAL_II VERSIONS                                                    ##
################################################################################
  message("deal.II will be installed in the following versions (*main version)")
  foreach(arg ${DEALII_VERSIONS})
    message("\t- ${arg}")
  endforeach()
  
################################################################################
## APPLICATIONS                                                               ##
################################################################################
  message("\nThe following applications have been chosen for installation")
  if(${INSTALL_aspect})
    message("\tASPECT version ${BUILD_ASPECT_VERSION}")
  endif()
  message(" ")

################################################################################
## FURTHER INFO                                                               ##
################################################################################
  message("If you are happy with this configuration call")
  message("\tcmake --build ${CMAKE_BINARY_DIR}\n")



endmacro()
