cmake_minimum_required(VERSION 2.6)
project(nibblerd)
add_definitions(-std=c++11)
include_directories(include)
add_executable(nibblerd
				src/main.cpp
				src/service.cpp
				src/log.cpp
				include/service.hpp
				include/log.hpp
)
