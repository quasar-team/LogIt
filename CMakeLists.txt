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

set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(LOGIT_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}/cmake")

include("${LOGIT_CMAKE_DIR}/LogItOptions.cmake")
include("${LOGIT_CMAKE_DIR}/LogItSources.cmake")

if(LOGIT_BACKEND_STDOUTLOG)
    include("${LOGIT_CMAKE_DIR}/LogItBackendStdout.cmake")
endif()

if(LOGIT_BACKEND_BOOSTLOG)
    include("${LOGIT_CMAKE_DIR}/LogItBackendBoostlog.cmake")
endif()

if(LOGIT_BACKEND_UATRACE)
    include("${LOGIT_CMAKE_DIR}/LogItBackendUatrace.cmake")
endif()

if(LOGIT_BACKEND_WINDOWS_DEBUGGER)
    include("${LOGIT_CMAKE_DIR}/LogItBackendWindowsDebugger.cmake")
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
