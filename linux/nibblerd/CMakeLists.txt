cmake_minimum_required(VERSION 2.6)
project(nibblerd)
add_definitions(-std=c++11)
include_directories(include)
set(CMAKE_CXX_FLAGS, "-DLOG_DEBUG_ACTIVE")
add_executable(nibblerd
				src/main.cpp
				src/service.cpp
				src/log.cpp
				src/server.cpp
				src/config.cpp
				include/service.hpp
				include/log.hpp
				include/server.hpp
				include/config.hpp
)
target_link_libraries(nibblerd dl)
target_link_libraries(nibblerd pthread)
