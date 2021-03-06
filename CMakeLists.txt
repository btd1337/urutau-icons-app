# project name
    project (com.github.btd1337.urutau-icons-app)

    # the oldest stable cmake version we support
    cmake_minimum_required (VERSION 2.6)

    # tell cmake where its modules can be found in our project directory
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

    # where we install data directory (if we have any)
    set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

    # where install icons
    set (ICONSDIR "/usr/share/icons/hicolor/")

    # what to call that directory where we install data too
    set (PKGDATADIR "${DATADIR}/com.github.btd1337.urutau-icons-app")

    set (EXEC_NAME "com.github.btd1337.urutau-icons-app")
    set (RELEASE_NAME "Alpha")
    set (VERSION "0.2")
    set (VERSION_INFO "Start")

    # we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
    find_package(PkgConfig)

    # now let's actually check for the required dependencies
    pkg_check_modules(DEPS REQUIRED gtk+-3.0)

    add_definitions(${DEPS_CFLAGS})
    link_libraries(${DEPS_LIBRARIES})
    link_directories(${DEPS_LIBRARY_DIRS})

    # make sure we have vala
    find_package(Vala REQUIRED)
    # make sure we use vala
    include(ValaVersion)
    # make sure it's the desired version of vala
    ensure_vala_version("0.16" MINIMUM)

    # files we want to compile
    include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME}
        src/urutau_icons.vala
    # tell what libraries to use when compiling
    PACKAGES
        gtk+-3.0
    )

    # tell cmake what to call the executable we just made
    add_executable(${EXEC_NAME} ${VALA_C})

    # install the binaries we just made
    install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

    # install our .desktop file so the Applications menu will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.btd1337.urutau-icons-app.desktop DESTINATION ${DATADIR}/applications/)

    # install our .appdata.xml file so AppCenter will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.btd1337.urutau-icons-app.appdata.xml DESTINATION ${DATADIR}/metainfo/)
    
    # install our ui file
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/urutau_icons.ui DESTINATION ${PKGDATADIR}/)
    
    # install assets
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/logo.png DESTINATION ${PKGDATADIR}/)

    # install icons
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/16/urutau-icons.svg DESTINATION ${ICONSDIR}/16x16/apps/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/24/urutau-icons.svg DESTINATION ${ICONSDIR}/24x24/apps/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/32/urutau-icons.svg DESTINATION ${ICONSDIR}/32x32/apps/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/48/urutau-icons.svg DESTINATION ${ICONSDIR}/48x48/apps/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/64/urutau-icons.svg DESTINATION ${ICONSDIR}/64x64/apps/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/128/urutau-icons.svg DESTINATION ${ICONSDIR}/128x128/apps/)

    option (ICON_UPDATE "Run gtk-update-icon-cache after the install." ON)
    if (ICON_UPDATE)
      install (CODE "message(\"-- Updating icon cache...\")")
      install (CODE "execute_process(COMMAND gtk-update-icon-cache -f -t ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor)")
    endif (ICON_UPDATE)
