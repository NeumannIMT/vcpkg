include_guard(GLOBAL)
#include("${CMAKE_CURRENT_LIST_DIR}/config.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/${VCPKG_TARGET_TRIPLET}.cmake")

# Set C standard.
#set(CMAKE_C_STANDARD 11 CACHE STRING "")
#set(CMAKE_C_STANDARD_REQUIRED ON CACHE STRING "")
#set(CMAKE_C_EXTENSIONS ON CACHE STRING "")

# Set C++ standard.
#set(CMAKE_CXX_STANDARD 20 CACHE STRING "")
#set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE STRING "")
#set(CMAKE_CXX_EXTENSIONS OFF CACHE STRING "")

# Set compiler.
if (DEFINED ENV{ProgramW6432})
    file(TO_CMAKE_PATH "$ENV{ProgramW6432}" PROG_ROOT)
else()
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" PROG_ROOT)
endif()
if(NOT PROG_ROOT MATCHES "(x86)")
    set(PROG_ROOT "${PROG_ROOT} (x86)")
endif()

file(TO_CMAKE_PATH "${PROG_ROOT}/Intel/OneAPI/compiler/latest/windows" POSSIBLE_INTEL_COMPILER_ROOT)
find_program(IFORT_EXECUTBALE NAMES "ifort" "ifort.exe" PATHS "${POSSIBLE_INTEL_COMPILER_ROOT}/bin/intel64")
find_program(CL_EXECUTBALE NAMES "cl" "cl.exe")

if(NOT IFORT_EXECUTBALE)
  message(SEND_ERROR "Intel Fortran Compiler was not found!")
endif()

get_filename_component(INTEL_BIN_DIR "${IFORT_EXECUTBALE}" DIRECTORY)
list(INSERT CMAKE_PROGRAM_PATH 0 "${INTEL_BIN_DIR}")

set(CMAKE_C_COMPILER "${CL_EXECUTBALE}" CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER "${CL_EXECUTBALE}" CACHE STRING "" FORCE)
set(CMAKE_Fortran_COMPILER "${IFORT_EXECUTBALE}" CACHE STRING "" FORCE) 

# Set runtime library.
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<STREQUAL:${VCPKG_CRT_LINKAGE},dynamic>:DLL>" CACHE STRING "")
if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
  set(VCPKG_CRT_FLAG "/MD")
  set(VCPKG_DBG_FLAG "/Z7")
elseif(VCPKG_CRT_LINKAGE STREQUAL "static")
  set(VCPKG_CRT_FLAG "/MT")
  set(VCPKG_DBG_FLAG "/Z7")
else()
  message(FATAL_ERROR "Invalid VCPKG_CRT_LINKAGE: \"${VCPKG_CRT_LINKAGE}\".")
endif()

# Set compiler flags.
# Disable logo for compiler and linker.
set(CMAKE_CL_NOLOGO "/nologo" CACHE STRING "")
#set(VCPKG_INTEL_FLAGS "/Qm64 /QxAVX /arch:AVX")
#set(MSVC_VERSION 1928)


set(CMAKE_C_FLAGS "${CMAKE_CL_NOLOGO} /DWIN32 /D_WINDOWS /FC ${VCPKG_C_FLAGS} ${CHARSET_FLAG}" CACHE STRING "")
set(CMAKE_C_FLAGS_DEBUG "/Od /Ob0 /GS /RTC1 ${VCPKG_C_FLAGS_DEBUG} ${VCPKG_CRT_FLAG}d ${VCPKG_DBG_FLAG}" CACHE STRING "")
set(CMAKE_C_FLAGS_RELEASE "/O1 /Oi /Ob2 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} /DNDEBUG" CACHE STRING "")
set(CMAKE_C_FLAGS_MINSIZEREL "/O1 /Oi /Ob1 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} /DNDEBUG" CACHE STRING "")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "/O2 /Oi /Ob1 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} ${VCPKG_DBG_FLAG} /DNDEBUG" CACHE STRING "")

# TODO: Remove /U__cpp_concepts once LLVM adds MS STL support.
set(CMAKE_CXX_FLAGS "${CMAKE_CL_NOLOGO} /DWIN32 /D_WINDOWS /FC /permissive- ${VCPKG_CXX_FLAGS} ${CHARSET_FLAG}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${VCPKG_CXX_FLAGS_DEBUG}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")

# Set linker flags.
foreach(LINKER SHARED_LINKER MODULE_LINKER EXE_LINKER)
  set(CMAKE_${LINKER}_FLAGS_INIT "${VCPKG_LINKER_FLAGS}")
  set(CMAKE_${LINKER}_FLAGS_DEBUG "/INCREMENTAL /DEBUG:FULL" CACHE STRING "")
  set(CMAKE_${LINKER}_FLAGS_RELEASE "/OPT:REF /OPT:ICF" CACHE STRING "")
  set(CMAKE_${LINKER}_FLAGS_MINSIZEREL "/OPT:REF /OPT:ICF" CACHE STRING "")
  set(CMAKE_${LINKER}_FLAGS_RELWITHDEBINFO "/OPT:REF /OPT:ICF /DEBUG:FULL" CACHE STRING "")
endforeach()

# Set assembler flags.
set(CMAKE_ASM_MASM_FLAGS_INIT "${CMAKE_CL_NOLOGO}")

# Set resource compiler flags.
set(CMAKE_RC_FLAGS_INIT "${CMAKE_CL_NOLOGO} -c65001 -DWIN32")
set(CMAKE_RC_FLAGS_DEBUG_INIT "-D_DEBUG")

# Add windows defines.
add_compile_definitions(_WIN64 _WIN32_WINNT=0x0A00 WINVER=0x0A00)
add_compile_definitions(_CRT_SECURE_NO_DEPRECATE _CRT_SECURE_NO_WARNINGS _CRT_NONSTDC_NO_DEPRECATE)
add_compile_definitions(_ATL_SECURE_NO_DEPRECATE _SCL_SECURE_NO_WARNINGS)