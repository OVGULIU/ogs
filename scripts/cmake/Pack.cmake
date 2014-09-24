#### Packaging setup ####
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "OGS-6")
SET(CPACK_PACKAGE_VENDOR "OpenGeoSys Community (http://www.opengeosys.org)")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "OGS-${OGS_VERSION_MAJOR}.${OGS_VERSION_MINOR}.${OGS_VERSION_PATCH}")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/README.md")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE.txt")
SET(CPACK_PACKAGE_VERSION_MAJOR "${OGS_VERSION_MAJOR}")
SET(CPACK_PACKAGE_VERSION_MINOR "${OGS_VERSION_MINOR}")
SET(CPACK_PACKAGE_VERSION_PATCH "${OGS_VERSION_PATCH}")
SET(CPACK_PACKAGE_FILE_NAME "ogs-${OGS_VERSION}-${CMAKE_SYSTEM}-x${BITS}")

IF(APPLE)
	IF(CMAKE_INSTALL_PREFIX MATCHES "/usr/local")
		SET(CMAKE_INSTALL_PREFIX "/Applications")
	ENDIF()
	SET(CMAKE_OSX_ARCHITECTURES "x86_64")
	SET(CPACK_GENERATOR "DragNDrop")
	SET(CPACK_DMG_FORMAT "UDBZ")
	SET(CPACK_DMG_VOLUME_NAME "${PROJECT_NAME}")
	# See http://stackoverflow.com/a/16662169/80480 how to create the DS_Store file.
	SET(CPACK_DMG_BACKGROUND_IMAGE ${CMAKE_SOURCE_DIR}/Documentation/OpenGeoSys-Logo.png)
	SET(CPACK_DMG_DS_STORE ${CMAKE_SOURCE_DIR}/scripts/packaging/.DS_Store)
	SET(CPACK_SYSTEM_NAME "OSX")
ELSE() # APPLE
	IF (WIN32)
		IF(OGS_PACKAGING_NSIS)
			SET(CPACK_GENERATOR NSIS)
			# There is a bug in NSI that does not handle full unix paths properly. Make
			# sure there is at least one set of four (4) backlasshes.
			#SET(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/CMakeConfiguration\\\\OGS_Logo_Installer.bmp")
			#SET(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\MyExecutable.exe")
			SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_DESCRIPTION_SUMMARY}")
			SET(CPACK_NSIS_HELP_LINK "https:\\\\\\\\www.opengeosys.org")
			SET(CPACK_NSIS_URL_INFO_ABOUT "http:\\\\\\\\www.opengeosys.org")
			SET(CPACK_NSIS_CONTACT "info@opengeosys.org")
			SET(CPACK_NSIS_MODIFY_PATH ON)
			# SET(CPACK_NSIS_MENU_LINKS "http://www.opengeosys.org" "OGS Project Page")
			# SET(CPACK_NSIS_MENU_LINKS "http://www.opengeosys.org/forum/" "OGS forum")
			# SET(CPACK_NSIS_MENU_LINKS "https://github.com/ufz/ogs" "OGS source code")
			# SET(CPACK_NSIS_MENU_LINKS "http://devguide.opengeosys.org" "OGS developer guide")
		ELSE()
			SET(CPACK_GENERATOR ZIP)
			SET(CPACK_PACKAGE_FILE_NAME "ogs-6")
		ENDIF()
	ENDIF() # WIN32

	IF(UNIX)
		SET(CPACK_GENERATOR TGZ)
	ENDIF()

	SET(CPACK_COMPONENT_OGS_DISPLAY_NAME "Executable")
	SET(CPACK_COMPONENT_OGS_DESCRIPTION "The command line executable")

	SET(CPACK_COMPONENTS_ALL_IN_ONE_PACKAGE 1)
	IF(OGS_BUILD_GUI)
		SET(CPACK_PACKAGE_EXECUTABLES "DataExplorer" "OGS User Interface")
		SET(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} ogs_gui Unspecified)
		SET(CPACK_COMPONENT_OGS_GUI_DISPLAY_NAME "Data Explorer")
		SET(CPACK_COMPONENT_OGS_GUI_DESCRIPTION "The graphical user interface for OpenGeoSys")
		#SET(CPACK_COMPONENT_OGS_GUI_DEPENDS ogs)
	ELSE()
		# SET(CPACK_PACKAGE_EXECUTABLES "ogs" "OGS Command Line")
		# SET(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} ogs Unspecified)
	ENDIF()
ENDIF() # APPLE

# Additional binaries, i.e. OGS-5 file converter
# Can be given as a list, paths must be relative to CMAKE_BINARY_DIR!
IF(OGS_PACKAGE_ADDITIONAL_BINARIES)
	FOREACH(ADDITIONAL_BINARY ${OGS_PACKAGE_ADDITIONAL_BINARIES})
		GET_FILENAME_COMPONENT(ADDITIONAL_BINARY_NAME ${ADDITIONAL_BINARY} NAME)
		MESSAGE(STATUS "Packaging additional binary: ${ADDITIONAL_BINARY_NAME}")
		IF(APPLE)
			SET(INSTALL_LOCATION DataExplorer.app/Contents/MacOS)
		ELSE()
			SET(INSTALL_LOCATION bin)
		ENDIF()
		INSTALL (PROGRAMS ${CMAKE_BINARY_DIR}/${ADDITIONAL_BINARY} DESTINATION ${INSTALL_LOCATION} COMPONENT ogs_extras)
	ENDFOREACH()
ENDIF()

INCLUDE (CPack)
