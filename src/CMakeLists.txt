INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

FILE(GLOB THERMOCHIMICA_SOURCES ${CMAKE_CURRENT_SOURCE_DIR} "*.f90")
TRIBITS_ADD_LIBRARY(thermochimica SOURCES ${THERMOCHIMICA_SOURCES})
