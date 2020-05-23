vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libffi/libffi
    REF v3.3
    SHA512 62798fb31ba65fa2a0e1f71dd3daca30edcf745dc562c6f8e7126e54db92572cc63f5aa36d927dd08375bb6f38a2380ebe6c5735f35990681878fc78fc9dbc83
    HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/libffiConfig.cmake.in DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DFFI_CONFIG_FILE=${CMAKE_CURRENT_LIST_DIR}/fficonfig.h
    OPTIONS_DEBUG
        -DFFI_SKIP_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_cmake_targets()

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/ffi.h
        "   *know* they are going to link with the static library.  */"
        "   *know* they are going to link with the static library.  */

#define FFI_BUILDING
"
    )
endif()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

# Add *.pc file for consumption
set(_file "${SOURCE_PATH}/libffi.pc.in")
file(READ "${_file}" _contents)
string(REPLACE "includedir=\${libdir}/@PACKAGE_NAME@-@PACKAGE_VERSION@/include" "includedir=@includedir@" _contents "${_contents}")
file(WRITE "${_file}" "${_contents}")

set(prefix "${CURRENT_INSTALLED_DIR}")
set(exec_prefix "\${prefix}")
set(libdir "\${prefix}/lib")
set(toolexeclibdir "\${prefix}/lib")
set(includedir "\${prefix}/include")
set(PACKAGE_NAME ffi)
set(PACKAGE_VERSION 3.3)
configure_file("${SOURCE_PATH}/libffi.pc.in" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libffi.pc" @ONLY)
set(prefix "${CURRENT_INSTALLED_DIR}/debug")
configure_file("${SOURCE_PATH}/libffi.pc.in" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libffi.pc" @ONLY)
vcpkg_fixup_pkgconfig()
