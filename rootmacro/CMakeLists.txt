cmake_minimum_required(VERSION 2.6 FATAL_ERROR)
set(NAME_MAIN_PROGRAM make_tree)
project(${NAME_MAIN_PROGRAM})

# ROOT
list(APPEND CMAKE_PREFIX_PATH $ENV{ROOTSYS})
find_package(ROOT CONFIG REQUIRED)
include(${ROOT_USE_FILE})

add_definitions(${ROOT_CXX_FLAGS})
add_executable(${NAME_MAIN_PROGRAM} ${NAME_MAIN_PROGRAM}.cxx)
target_link_libraries(${NAME_MAIN_PROGRAM} ROOT::Tree)
