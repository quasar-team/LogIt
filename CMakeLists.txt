# LICENSE:
# Copyright (c) 2015, CERN
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

# Author: Ben Farnham <ben.farnham@cern.ch>

cmake_minimum_required(VERSION 2.8)

# C++11 as standard
set (CMAKE_CXX_STANDARD 11) # works for CMake v3.1+
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11") #for older CMake versions

if( NOT DEFINED ENV{BOOST_PATH_HEADERS} )
    message(FATAL_ERROR "environment variable BOOST_PATH_HEADERS not defined - please set this to a 64bit boost installation include directory")
endif()
if( NOT DEFINED ENV{BOOST_PATH_LIBS} )
    message(FATAL_ERROR "environment variable BOOST_HOME not defined - please set this to a 64bit boost installation library directory")
endif()
message(STATUS "BOOST - include [${BOOST_PATH_HEADERS}] libs [${BOOST_PATH_LIBS}] BOOST_LIB_SUFFIX [$ENV{BOOST_LIB_SUFFIX}]")

SET( BOOST_PATH_HEADERS $ENV{BOOST_HOME}/include )
SET( BOOST_PATH_LIBS $ENV{BOOST_HOME}/lib )

set(LOGIT_SOURCES
    src/LogIt.cpp
    src/LogLevels.cpp
    src/LogRecord.cpp
    src/LogSinks.cpp
    src/ComponentAttributes.cpp
    src/LogItInstance.cpp
) 
   
if( NOT DEFINED LOGIT_HAS_BOOSTLOG )
	set (LOGIT_HAS_BOOSTLOG FALSE)
endif()

if( NOT DEFINED LOGIT_HAS_STDOUTLOG )
	set (LOGIT_HAS_STDOUTLOG TRUE)
endif()

if( NOT DEFINED LOGIT_HAS_UATRACE )
	set (LOGIT_HAS_UATRACE FALSE)
endif()

# handle binary library build (builds with -DSTANDALONE_BUILD=ON)
option(STANDALONE_BUILD "Build it as a stand-alone library (i.e. as opposed to an Quasar internal module)" OFF )
if(STANDALONE_BUILD)
  add_library( LogIt_shared SHARED ${LOGIT_SOURCES} )
  add_library( LogIt_static STATIC ${LOGIT_SOURCES} )
  include_directories( 
    include
    ${BOOST_PATH_HEADERS}
  )
else(STANDALONE_BUILD)
  add_library (LogIt OBJECT ${LOGIT_SOURCES}) 
endif(STANDALONE_BUILD)

MESSAGE( STATUS "LogIt build options: STANDALONE_BUILD [${STANDALONE_BUILD}], backends: LOGIT_HAS_STDOUTLOG [${LOGIT_HAS_STDOUTLOG}] LOGIT_HAS_BOOSTLOG [${LOGIT_HAS_BOOSTLOG}] LOGIT_HAS_UATRACE [${LOGIT_HAS_UATRACE}]" )

if(${LOGIT_HAS_BOOSTLOG})
    add_definitions(-DLOGIT_HAS_BOOSTLOG)
    set(LOGIT_SOURCES ${LOGIT_SOURCES} src/BoostRotatingFileLog.cpp)
endif(${LOGIT_HAS_BOOSTLOG})  

if(${LOGIT_HAS_STDOUTLOG})
    add_definitions(-DLOGIT_HAS_STDOUTLOG)
    set(LOGIT_SOURCES ${LOGIT_SOURCES} src/StdOutLog.cpp)
endif(${LOGIT_HAS_STDOUTLOG})

if(${LOGIT_HAS_UATRACE})
    add_definitions(-DLOGIT_HAS_UATRACE)
    set(LOGIT_SOURCES ${LOGIT_SOURCES} src/UaTraceSink.cpp)
endif(${LOGIT_HAS_UATRACE})

set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
MESSAGE( STATUS "building LogIt from source files [${LOGIT_SOURCES}]" )
