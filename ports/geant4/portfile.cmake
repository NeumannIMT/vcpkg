vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Geant4/geant4
    REF 2d174b7a10d70c0bc257ede0554bfcab14e75db5
    SHA512 bdbaa8a5fc77f4e5f124f464a40ce2283309f50fa679e2fdd1c00c555281effa9aaa7b6e241cf4312f44e35248ee69be6fe2b882602fabff0a4900b6ffb68069
    HEAD_REF master
    PATCHES
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets()

if(TOOL_NAMES)
    vcpkg_copy_tools(TOOL_NAMES ${TOOL_NAMES} AUTO_CLEAN)
endif()


file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
