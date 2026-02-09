list(APPEND LOGIT_SOURCES src/BoostRotatingFileLog.cpp)
list(APPEND LOGIT_DEFINITIONS LOGIT_BACKEND_BOOSTLOG)

set(BOOST_HOME "$ENV{BOOST_HOME}")
if(NOT BOOST_HOME)
    message(FATAL_ERROR "LOGIT_BACKEND_BOOSTLOG requires BOOST_HOME to be set (e.g. /boost with lib/cmake/Boost-<version>/BoostConfig.cmake).")
endif()

if(NOT EXISTS "${BOOST_HOME}")
    message(FATAL_ERROR "BOOST_HOME does not exist: ${BOOST_HOME}")
endif()

list(APPEND CMAKE_PREFIX_PATH "${BOOST_HOME}")
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_STATIC_RUNTIME ON)
find_package(Boost CONFIG REQUIRED COMPONENTS log)

if(NOT TARGET Boost::log)
    message(FATAL_ERROR "Boost CMake config did not provide Boost::log target.")
endif()

list(APPEND LOGIT_EXTRA_LINK_LIBS Boost::log)
