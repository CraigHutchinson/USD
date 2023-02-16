# @see https://cmake.org/cmake/help/latest/command/cmake_language.html#dependency-providers
# @usage `cmake -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=cpm_dependency_provider.cmake`

# Always ensure we have the policy settings this provider expects
cmake_minimum_required(VERSION 3.24)

# TEMP
if( NOT BOOST_REQUESTED_VERSION)
	set(BOOST_REQUESTED_VERSION 1.78.0)
endif()

macro(cpm_provide_dependency method package_name)

	list(REMOVE_ITEM ${ARGN} REQUIRED) # @note Find package as optional in system/local install
	find_package(${package_name} BYPASS_PROVIDER QUIET) 
	
	if ( NOT ${package_name}_FOUND)
		find_package(CPM REQUIRED BYPASS_PROVIDER)

		if("${package_name}" MATCHES "^(Boost)$")
			if(NOT BOOST_REQUESTED_VERSION)
				message(FATAL_ERROR "BOOST_REQUESTED_VERSION is not defined.")
			endif()
			string(REPLACE "." "_" BOOST_REQUESTED_VERSION_UNDERSCORE ${BOOST_REQUESTED_VERSION})
			set(BOOST_URL "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_REQUESTED_VERSION}/source/boost_${BOOST_REQUESTED_VERSION_UNDERSCORE}.tar.gz")

			CPMAddPackage( NAME Boost
			  VERSION ${BOOST_REQUESTED_VERSION}
			  URL ${BOOST_URL}
			  DOWNLOAD_ONLY YES 
			)
			if(Boost_ADDED)
				set(BOOST_ROOT ${Boost_SOURCE_DIR}) # either set it here or from the command line 
				# TODO; Boost options
				#set(Boost_USE_STATIC_LIBS OFF) 
				#set(Boost_USE_MULTITHREADED ON)  
				#set(Boost_USE_STATIC_RUNTIME OFF) 
			
				# TODO; explicit find or not!
				#find_package(${package_name} ${ARGN} BYPASS_PROVIDER) 
			endif()
		endif()
	endif()

	
endmacro()

cmake_language(
  SET_DEPENDENCY_PROVIDER cpm_provide_dependency
  SUPPORTED_METHODS FIND_PACKAGE
)