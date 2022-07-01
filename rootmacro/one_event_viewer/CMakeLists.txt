set(NAME_MAIN_PROGRAM one_event_viewer)
project(${NAME_MAIN_PROGRAM})

# ROOT
list(APPEND CMAKE_PREFIX_PATH $ENV{ROOTSYS})
find_package(ROOT CONFIG REQUIRED)
include(${ROOT_USE_FILE})

add_definitions(${ROOT_CXX_FLAGS})
add_executable(${NAME_MAIN_PROGRAM} ${NAME_MAIN_PROGRAM}.cxx)
target_link_libraries(${NAME_MAIN_PROGRAM} ROOT::Core ROOT::Graf ROOT::Gpad ROOT::Tree)
install(
    TARGETS ${NAME_MAIN_PROGRAM}
    DESTINATION .
    )