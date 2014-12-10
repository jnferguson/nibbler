cmake_minimum_required(VERSION 2.8)
project(nibblerd)
add_definitions(-std=c++11)
include_directories(include /usr/include/botan-1.11)

add_executable(nibblerd
				src/main.cpp
				src/service.cpp
				src/log.cpp
				src/server.cpp
				src/config.cpp
				src/convert.cpp
				src/nibbler.cpp
				src/file.cpp				
				src/ssl.cpp
				include/service.hpp
				include/log.hpp
				include/server.hpp
				include/config.hpp
				include/convert.hpp
				include/nibbler.hpp
				include/file.hpp
				include/ssl.hpp
)
#INCLUDE_DIRECTORIES(/opt/libressl/include)
#ADD_LIBRARY(libressl_ssl SHARED IMPORTED)
#SET_TARGET_PROPERTIES(libressl_ssl PROPERTIES IMPORTED_LOCATION
#		/opt/libressl/lib/libssl.so)
#ADD_LIBRARY(libressl_crypto SHARED IMPORTED)
#SET_TARGET_PROPERTIES(libressl_crypto PROPERTIES IMPORTED_LOCATION
#		/opt/libressl/lib/libcrypto.so)
target_link_libraries(nibblerd ssl)
target_link_libraries(nibblerd crypto)
target_link_libraries(nibblerd dl)
target_link_libraries(nibblerd pthread)
#target_link_libraries(nibblerd botan-1.11)
