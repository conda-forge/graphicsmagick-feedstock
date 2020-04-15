# adopted from https://github.com/microsoft/vcpkg/blob/master/ports/graphicsmagick/CMakeLists.txt
cmake_minimum_required (VERSION 3.6)
project (graphicsmagick)

find_package(ZLIB REQUIRED)
find_package(BZip2 REQUIRED)
find_package(JPEG REQUIRED)
find_package(PNG REQUIRED)
find_package(TIFF REQUIRED)
find_package(Freetype REQUIRED)

include_directories(".")
include_directories("Magick++/lib")

add_definitions(-D_DLL -DDLL -D_MT -DWIN64)

if (MSVC)
    add_definitions(-D_VISUALC_ -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)
endif ()

file(READ "magick/magick_config.h.in" CONFIG_H)
string(REPLACE "#undef HasBZLIB" "#define HasBZLIB" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasJPEG" "#define HasJPEG" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasPNG" "#define HasPNG" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasTIFF" "#define HasTIFF" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasTTF" "#define HasTTF" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasTTF" "#define HasTTF" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HAVE_FT2BUILD_H" "/* #undef HAVE_FT2BUILD_H */" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasZLIB" "#define HasZLIB" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasJBIG" "/* #undef HasJBIG */" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef QuantumDepth" "#define QuantumDepth 16" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef restrict" "#define restrict" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef size_t" "/* #undef size_t */" CONFIG_H "${CONFIG_H}")
string(REPLACE "#undef HasWINGDI32" "#define HasWINGDI32" CONFIG_H "${CONFIG_H}")
file(WRITE "magick/magick_config.h" "${CONFIG_H}")

file(READ "magick/magick_config_api.h.in" CONFIG_API_H)
string(REPLACE "#undef QuantumDepth" "#define QuantumDepth 16" CONFIG_API_H "${CONFIG_API_H}")
string(REPLACE "#undef size_t" "/* #undef size_t */" CONFIG_API_H "${CONFIG_API_H}")
file(WRITE "magick/magick_config_api.h" "${CONFIG_API_H}")

file(GLOB GRAPHICSMAGICK_SOURCES coders/*.c filters/*.c magick/*.c)
file(GLOB GRAPHICSMAGICK_SOURCES_EXCLUDES coders/jbig.c coders/webp.c wand/wandtest.c wand/drawtest.c)
list(REMOVE_ITEM GRAPHICSMAGICK_SOURCES ${GRAPHICSMAGICK_SOURCES_EXCLUDES})

file(GLOB GRAPHICSMAGICKWAND_SOURCES wand/*.c)
file(GLOB GRAPHICSMAGICKWAND_SOURCES_EXCLUDES wand/wandtest.c wand/drawtest.c)
list(REMOVE_ITEM GRAPHICSMAGICKWAND_SOURCES ${GRAPHICSMAGICKWAND_SOURCES_EXCLUDES})

file(GLOB GRAPHICSMAGICKPLUSPLUS_SOURCES Magick++/lib/*.cpp)

file(GLOB MAGICK_HEADERS magick/*.h)
file(GLOB MAGICKPLUSPLUS_ROOT_HEADERS Magick++/lib/*.h)
file(GLOB MAGICKPLUSPLUS_HEADERS Magick++/lib/Magick++/*.h)
file(GLOB WAND_HEADERS wand/*.h)

add_library(GraphicsMagick ${GRAPHICSMAGICK_SOURCES})

add_library(GraphicsMagickWand ${GRAPHICSMAGICKWAND_SOURCES})

add_library(GraphicsMagick++ ${GRAPHICSMAGICKPLUSPLUS_SOURCES})

add_executable(gm utilities/gm.c)

TARGET_LINK_LIBRARIES(GraphicsMagick PRIVATE
    ZLIB::ZLIB
    BZip2::BZip2
    JPEG::JPEG
    PNG::PNG
    TIFF::TIFF
    Freetype::Freetype
)
TARGET_LINK_LIBRARIES(GraphicsMagickWand GraphicsMagick)
TARGET_LINK_LIBRARIES(GraphicsMagick++ GraphicsMagick)
TARGET_LINK_LIBRARIES(gm GraphicsMagick)

target_compile_definitions(GraphicsMagick PRIVATE _MAGICKLIB_)
target_compile_definitions(GraphicsMagickWand PRIVATE _WANDLIB_)

install(TARGETS GraphicsMagick GraphicsMagickWand GraphicsMagick++ gm
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib)

install(FILES ${MAGICK_HEADERS} DESTINATION include/GraphicsMagick/magick)
install(FILES ${MAGICKPLUSPLUS_ROOT_HEADERS} DESTINATION include/GraphicsMagick)
install(FILES ${MAGICKPLUSPLUS_HEADERS} DESTINATION include/GraphicsMagick/Magick++)
install(FILES ${WAND_HEADERS} DESTINATION include/GraphicsMagick/wand)
