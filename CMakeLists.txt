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
cmake_minimum_required(VERSION 3.10)
project(LogIt CXX)

#
# common settings for static/shared library compilation
#
set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(LOGIT_BACKEND_STDOUTLOG "The basic back-end: logs to stdout" ON)
option(LOGIT_BACKEND_BOOSTLOG "Rotating file logger back-end: fixed size on disk based on boost logging library" OFF)
option(LOGIT_BACKEND_UATRACE "UnifiedAutomation toolkit logger" OFF)
option(LOGIT_BACKEND_WINDOWS_DEBUGGER "Windows debugger logger" OFF)
# handle binary library build (builds with -DLOGIT_BUILD_SHARED_LIB=ON)
option(LOGIT_BUILD_SHARED_LIB "Build a LogIt shared library if ON (otherwise builds an object library)" OFF)

set(LOGIT_EXTRA_INCLUDE_DIRS "")
set(LOGIT_EXTRA_LINK_LIBS "")

set(LOGIT_SOURCES
    src/LogIt.cpp
    src/LogLevels.cpp
    src/LogRecord.cpp
    src/LogSinks.cpp
    src/ComponentAttributes.cpp
    src/LogItInstance.cpp
)

if(LOGIT_BACKEND_STDOUTLOG)
    list(APPEND LOGIT_SOURCES src/StdOutLog.cpp)
    list(APPEND LOGIT_DEFINITIONS LOGIT_BACKEND_STDOUTLOG)
endif()

if(LOGIT_BACKEND_BOOSTLOG)
    list(APPEND LOGIT_SOURCES src/BoostRotatingFileLog.cpp)
    list(APPEND LOGIT_DEFINITIONS LOGIT_BACKEND_BOOSTLOG)

    set(BOOST_HOME "$ENV{BOOST_HOME}")
    if(NOT BOOST_HOME)
        message(FATAL_ERROR "LOGIT_BACKEND_BOOSTLOG requires BOOST_HOME to be set (e.g. /boost with include/ and lib/).")
    endif()
    set(BOOST_INCLUDE_DIR "${BOOST_HOME}/include")
    set(BOOST_LIBRARY_DIR "${BOOST_HOME}/lib")
    if(NOT EXISTS "${BOOST_INCLUDE_DIR}")
        message(FATAL_ERROR "BOOST_HOME does not contain include/: ${BOOST_INCLUDE_DIR}")
    endif()
    if(NOT EXISTS "${BOOST_LIBRARY_DIR}")
        message(FATAL_ERROR "BOOST_HOME does not contain lib/: ${BOOST_LIBRARY_DIR}")
    endif()

    list(APPEND LOGIT_EXTRA_INCLUDE_DIRS "${BOOST_INCLUDE_DIR}")
    foreach(_boost_lib boost_log)
        find_library(BOOST_${_boost_lib}_LIB NAMES "lib${_boost_lib}.a" PATHS "${BOOST_LIBRARY_DIR}" NO_DEFAULT_PATH)
        if(NOT BOOST_${_boost_lib}_LIB)
            message(FATAL_ERROR "Missing static Boost library lib${_boost_lib}.a in ${BOOST_LIBRARY_DIR}")
        endif()
        list(APPEND LOGIT_EXTRA_LINK_LIBS "${BOOST_${_boost_lib}_LIB}")
    endforeach()
endif()

if(LOGIT_BACKEND_UATRACE)
    list(APPEND LOGIT_SOURCES src/UaTraceSink.cpp)
    list(APPEND LOGIT_DEFINITIONS LOGIT_BACKEND_UATRACE)
endif()

if(LOGIT_BACKEND_WINDOWS_DEBUGGER)
    list(APPEND LOGIT_SOURCES src/WindowsDebuggerSink.cpp)
    list(APPEND LOGIT_DEFINITIONS LOGIT_BACKEND_WINDOWS_DEBUGGER)
endif()

message( STATUS "Building LogIt from source files [${LOGIT_SOURCES}]")
message( STATUS "LogIt build options: LOGIT_BUILD_SHARED_LIB [${LOGIT_BUILD_SHARED_LIB}], backends: LOGIT_BACKEND_STDOUTLOG [${LOGIT_BACKEND_STDOUTLOG}] LOGIT_BACKEND_BOOSTLOG [${LOGIT_BACKEND_BOOSTLOG}] LOGIT_BACKEND_UATRACE [${LOGIT_BACKEND_UATRACE}] LOGIT_BACKEND_WINDOWS_DEBUGGER [${LOGIT_BACKEND_WINDOWS_DEBUGGER}]")

if(LOGIT_BUILD_SHARED_LIB)
    add_library(LogIt SHARED ${LOGIT_SOURCES})
else()
    add_library(LogIt OBJECT ${LOGIT_SOURCES})
endif()

target_include_directories(LogIt
    PUBLIC
        ${LOGIT_EXTRA_INCLUDE_DIRS}
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)
if(LOGIT_DEFINITIONS)
    target_compile_definitions(LogIt PUBLIC ${LOGIT_DEFINITIONS})
endif()

if(LOGIT_EXTRA_LINK_LIBS)
    target_link_libraries(LogIt PUBLIC ${LOGIT_EXTRA_LINK_LIBS})
endif()
