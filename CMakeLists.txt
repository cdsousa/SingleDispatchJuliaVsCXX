cmake_minimum_required(VERSION 2.6)
project(subclassdispatchtests)
set(CMAKE_BUILD_TYPE Release)
add_definitions(-std=c++14)
add_executable(subclassdispatchtests subclassdispatchtests.cpp)
add_custom_target(run
    COMMAND subclassdispatchtests
    DEPENDS subclassdispatchtests
    WORKING_DIRECTORY ${CMAKE_PROJECT_DIR}
)
