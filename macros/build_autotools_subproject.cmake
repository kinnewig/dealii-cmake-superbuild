macro(build_autotools_subproject)
  # See cmake_parse_arguments docs to see how args get parsed here:
  #    https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html
  set(oneValueArgs NAME VERSION URL MD5 DOWNLOAD_ONLY)
  set(multiValueArgs CONFIGURE_FLAGS DEPENDS_ON)
  cmake_parse_arguments(BUILD_SUBPROJECT "" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})

  # Setup SUBPROJECT_* variables (containing paths) for this function
  setup_subproject_path_vars(${BUILD_SUBPROJECT_NAME})

   if (NOT DEFINED BUILD_SUBPROJECT_VERSION)  
    set(SUBPROJECT_INSTALL_PATH ${CMAKE_INSTALL_PREFIX})
  else()
    set(SUBPROJECT_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/${BUILD_SUBPROJECT_NAME}-${BUILD_SUBPROJECT_VERSION})
  endif()
  
  find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)
  
  set(SUBPROJECT_CONFIGURE_COMMAND ${CMAKE_BINARY_DIR}/${SUBPROJECT_SOURCE_PATH}/configure)
  set(SUBPROJECT_BUILD_COMMAND ${MAKE_EXECUTABLE} -j)
  set(SUBPROJECT_INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install)
  
  
  if(BUILD_SUBPROJECT_DOWNLOAD_ONLY)
    set(SUBPROJECT_CONFIGURE_COMMAND true)
    set(SUBPROJECT_BUILD_COMMAND true)
    set(BUILD_SUBPROJECT_INSTALL_COMMAND true)
  endif()

  set(subproject_LIBRARY ${SUBPROJECT_INSTALL_PATH}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BUILD_SUBPROJECT_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX})

  
  # Build the actual subproject
  ExternalProject_Add(${SUBPROJECT_NAME}
    BUILD_COMMAND ${SUBPROJECT_BUILD_COMMAND}
    INSTALL_COMMAND ${SUBPROJECT_INSTALL_COMMAND}
    UPDATE_DISCONNECTED true
    CONFIGURE_HANDLED_BY_BUILD true
    CONFIGURE_COMMAND ${SUBPROJECT_CONFIGURE_COMMAND} --prefix=${SUBPROJECT_INSTALL_PATH} ${BUILD_SUBPROJECT_CONFIGURE_FLAGS}
    PREFIX ${SUBPROJECT_NAME}
    DOWNLOAD_DIR ${SUBPROJECT_NAME}
    STAMP_DIR ${SUBPROJECT_STAMP_PATH}
    SOURCE_DIR ${SUBPROJECT_SOURCE_PATH}
    BINARY_DIR ${SUBPROJECT_BUILD_PATH}
    INSTALL_DIR ${SUBPROJECT_INSTALL_PATH}
    URL ${BUILD_SUBPROJECT_URL}
    URL_MD5 ${BUILD_SUBPROJECT_MD5}
    BUILD_BYPRODUCTS ${subproject_LIBRARY}
  )

  if(BUILD_SUBPROJECT_DEPENDS_ON)
    ExternalProject_Add_StepDependencies(${SUBPROJECT_NAME}
      configure ${BUILD_SUBPROJECT_DEPENDS_ON}
    )
  endif()

  add_library(${SUBPROJECT_NAME}::${SUBPROJECT_NAME} INTERFACE IMPORTED GLOBAL)
  target_include_directories(${SUBPROJECT_NAME}::${SUBPROJECT_NAME} INTERFACE ${SUBPROJECT_INSTALL_PATH}/include)
  target_link_libraries(${SUBPROJECT_NAME}::${SUBPROJECT_NAME} INTERFACE "${subproject_LIBRARY}")
  
  set(${BUILD_SUBPROJECT_NAME}_DIR ${SUBPROJECT_INSTALL_PATH})
endmacro()