vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO root-project/root
    REF a4a30f9d00f1400ef5e8ff51a2d06d1644b72759
    SHA512 1a281c3d12ae1af220b81a017e7f11d724e8e0ee2da191710c061308271267ff29d0126873c1d984931f3f9d2666a6cad374a7378b7e9d59a4fc75cb3cfeec29
    HEAD_REF master
    PATCHES
)
#https://root.cern/install/dependencies/
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
