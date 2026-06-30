list(APPEND LOGIT_SOURCES src/BoostRotatingFileLog.cpp)
list(APPEND LOGIT_DEFINITIONS LOGIT_BACKEND_BOOSTLOG)

if(DEFINED ENV{BOOST_HOME})
    message(STATUS "BOOST_HOME environment variable is set to: $ENV{BOOST_HOME}")
    message(STATUS "this will set BOOST to that folder in static mode")
    set(Boost_DIR $ENV{BOOST_HOME})
endif()

find_package(Boost CONFIG REQUIRED COMPONENTS log)

if(NOT TARGET Boost::log)
    message(FATAL_ERROR "Boost CMake config did not provide Boost::log target.")
endif()

if(NOT LOGIT_BUILD_SHARED_LIB)
    set_property(TARGET Boost::log PROPERTY IMPORTED_GLOBAL TRUE)
    get_directory_property(LOGIT_PARENT_DIRECTORY PARENT_DIRECTORY)
    if(LOGIT_PARENT_DIRECTORY)
        set_property(DIRECTORY "${LOGIT_PARENT_DIRECTORY}" APPEND PROPERTY LINK_LIBRARIES Boost::log)
    endif()
endif()

list(APPEND LOGIT_EXTRA_LINK_LIBS Boost::log)
