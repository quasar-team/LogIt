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
message( STATUS "using file [boost_standard_install.cmake] with BOOST_ROOT environment variable set to [$ENV{BOOST_ROOT}]. Using FindBoost." )

set( BOOST_LIBS_TO_FIND chrono )
if( LOGIT_BACKEND_BOOSTLOG )
  set( BOOST_LIBS_TO_FIND ${BOOST_LIBS_TO_FIND} log log_setup )
endif()

message( STATUS "Looking for boost libs [${BOOST_LIBS_TO_FIND}]" )
find_package( Boost REQUIRED COMPONENTS ${BOOST_LIBS_TO_FIND} )

if( NOT Boost_FOUND )
  message( FATAL_ERROR "Failed to find system boost installation (BOOST_ROOT environment variable correctly set ? value [$ENV{BOOST_ROOT}]" )
endif()

message( STATUS "Boost_VERSION [${Boost_VERSION}] Boost_VERSION_STRING [${Boost_VERSION_STRING}]" )
set( BOOST_LIBS Boost::chrono )
if( LOGIT_BACKEND_BOOSTLOG )
  set( BOOST_LIBS ${BOOST_LIBS} Boost::log Boost::log_setup )
endif()
