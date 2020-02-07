# LICENSE:
# Copyright (c) 2018, Ben Farnham, CERN
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Authors:
# Ben Farnham <firstNm.secondNm@cern.ch>
message(STATUS "Using file [boost_appveyor.cmake] toolchain file")
message(STATUS "Boost - include environment variable BOOST_PATH_HEADERS [$ENV{BOOST_PATH_HEADERS}] libs environment variable BOOST_PATH_LIBS [$ENV{BOOST_PATH_LIBS}]")

#-------
# Boost headers
#-------
if( NOT DEFINED ENV{BOOST_PATH_HEADERS} OR NOT EXISTS $ENV{BOOST_PATH_HEADERS} )
	message(FATAL_ERROR "environment variable BOOST_PATH_HEADERS must be set to a valid path for boost header files. Current value [$ENV{BOOST_PATH_HEADERS}] rejected")
endif()
message(STATUS "Boost - headers will be included from [$ENV{BOOST_PATH_HEADERS}]")
include_directories( $ENV{BOOST_PATH_HEADERS} )


#-------
# Boost compiled libs
#-------
if( NOT DEFINED ENV{BOOST_PATH_LIBS} OR NOT EXISTS $ENV{BOOST_PATH_LIBS} )
	message(FATAL_ERROR "environment variable BOOST_PATH_LIBS must be set to a valid path for boost compiled libraries. Current value [$ENV{BOOST_PATH_LIBS}] rejected")
endif()
message(STATUS "Boost - libraries will be linked from [$ENV{BOOST_PATH_LIBS}]")
link_directories( $ENV{BOOST_PATH_LIBS} )

function( find_boost_static_library LIBRARY_IDENTIFIER LIBRARY_SPECIFIC_PATH LIBRARY_FILE_NAME)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")
	SET(CMAKE_FIND_LIBRARY_PREFIXES "")

	find_library(${LIBRARY_IDENTIFIER} NAMES ${LIBRARY_FILE_NAME} PATHS $ENV{BOOST_PATH_LIBS}/${LIBRARY_SPECIFIC_PATH}  NO_DEFAULT_PATH)
	message(STATUS "${LIBRARY_IDENTIFIER} has value [${${LIBRARY_IDENTIFIER}}]")
	if(NOT ${LIBRARY_IDENTIFIER})
		message(FATAL_ERROR "Failed to load boost static library ID [${LIBRARY_IDENTIFIER}] paths [$ENV{BOOST_PATH_LIBS}/${LIBRARY_SPECIFIC_PATH}] name [${LIBRARY_FILE_NAME}]")
	endif()
	message(STATUS "loaded boost static library [${LIBRARY_IDENTIFIER}] -> file [${${LIBRARY_IDENTIFIER}}]")
endfunction()

if(${CMAKE_BUILD_TYPE} MATCHES Debug)
    set ( BOOST_DEBUG_LIB_MARKER "-gd" )
endif()

find_boost_static_library( libboostprogramoptions boost_program_options-vc141/lib/native libboost_program_options-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )
find_boost_static_library( libboostsystem boost_system-vc141/lib/native libboost_system-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )
find_boost_static_library( libboostfilesystem boost_filesystem-vc141/lib/native libboost_filesystem-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )
find_boost_static_library( libboostchrono boost_chrono-vc141/lib/native libboost_chrono-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )
find_boost_static_library( libboostdatetime boost_date_time-vc141/lib/native libboost_date_time-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )
find_boost_static_library( libboostthread boost_thread-vc141/lib/native libboost_thread-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )
find_boost_static_library( libboostlog boost_log-vc141/lib/native libboost_log-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )
find_boost_static_library( libboostlogsetup boost_log_setup-vc141/lib/native libboost_log_setup-vc141-mt${BOOST_DEBUG_LIB_MARKER}-x64-1_67 )

set( BOOST_LIBS ${libboostlogsetup} ${libboostlog} ${libboostsystem} ${libboostfilesystem} ${libboostthread} ${libboostprogramoptions} ${libboostchrono} ${libboostdatetime})
