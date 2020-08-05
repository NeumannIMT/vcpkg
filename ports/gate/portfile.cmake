vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO OpenGATE/Gate
    REF 6847a83d3cd86a782f80b96b4b761fa64f96162b
    SHA512 1f0d547f00f52c387f396f09b9a24b93ef04c54b1a84f338b38fd8e3c3e4056a42e908c28cb7f18e0a8a536fe7053ba454ba901a4887550aa45c7983391c2ea7
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
