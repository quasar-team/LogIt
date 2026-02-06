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
    find_library(BOOST_${_boost_lib}_LIB 
                NAMES 
                    "lib${_boost_lib}.a" 
                    "lib${_boost_lib}.lib" 
                    "lib${_boost_lib}-*.lib"
                PATHS "${BOOST_LIBRARY_DIR}" NO_DEFAULT_PATH)
    if(NOT BOOST_${_boost_lib}_LIB)
        message(FATAL_ERROR "Missing static Boost library lib${_boost_lib}${CMAKE_STATIC_LIBRARY_SUFFIX} in ${BOOST_LIBRARY_DIR}")
    endif()
    list(APPEND LOGIT_EXTRA_LINK_LIBS "${BOOST_${_boost_lib}_LIB}")
endforeach()

