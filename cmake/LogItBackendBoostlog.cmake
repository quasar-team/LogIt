list(APPEND LOGIT_SOURCES src/BoostRotatingFileLog.cpp)
list(APPEND LOGIT_DEFINITIONS LOGIT_BACKEND_BOOSTLOG)

if(DEFINED ENV{BOOST_HOME})
    message(STATUS "BOOST_HOME environment variable is set to: $ENV{BOOST_HOME}")
    message(STATUS "this will set BOOST to that folder in static mode")
    set(Boost_DIR $ENV{BOOST_HOME})
    set(Boost_USE_STATIC_RUNTIME ON)
    set(Boost_USE_STATIC_LIBS ON)
endif()

find_package(Boost CONFIG REQUIRED COMPONENTS log)

if(NOT TARGET Boost::log)
    message(FATAL_ERROR "Boost CMake config did not provide Boost::log target.")
endif()

list(APPEND LOGIT_EXTRA_LINK_LIBS Boost::log)
