
# @see https://cmake.org/cmake/help/latest/command/cmake_language.html#dependency-providers
# @usage `cmake -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=unity_dependency_provider.cmake`

# Always ensure we have the policy settings this provider expects
cmake_minimum_required(VERSION 3.24)

set(UNITY_PROVIDER_INSTALL_DIR ${CMAKE_BINARY_DIR}/unity_packages
  CACHE PATH "The directory this provider installs packages to"
)
# Tell the built-in implementation to look in our area first, unless
# the find_package() call uses NO_..._PATH options to exclude it
list(APPEND CMAKE_MODULE_PATH ${UNITY_PROVIDER_INSTALL_DIR}/cmake)
list(APPEND CMAKE_PREFIX_PATH ${UNITY_PROVIDER_INSTALL_DIR})

# TEMP
if( NOT BOOST_REQUESTED_VERSION)
	set(BOOST_REQUESTED_VERSION 1.78.0)
endif()

macro(unity_provide_dependency method package_name)
	if("${package_name}" MATCHES "^(Boost)$")
		# TODO
		message("Boost find not implemented")
	endif()
endmacro()

cmake_language(
  SET_DEPENDENCY_PROVIDER unity_provide_dependency
  SUPPORTED_METHODS FIND_PACKAGE
)