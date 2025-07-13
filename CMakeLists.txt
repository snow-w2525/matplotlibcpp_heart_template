cmake_minimum_required(VERSION 3.16)

# Set app name.
set(APP_NAME DrawHeart)

# Set project.
project(${APP_NAME} LANGUAGES CXX)

# Add Python package
find_package(Python REQUIRED COMPONENTS Interpreter Development)

# Set third-party paths
set(THIRD_PARTY_PATH ${CMAKE_SOURCE_DIR}/thirdParty)
set(MATPLOTLIB_PATH ${THIRD_PARTY_PATH}/matplotlib-cpp)

# Output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${APP_NAME})

# Build configurations (for multi-config generators only)
if(NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose Release or Debug" FORCE)
endif()

# C++ version
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Executable
add_executable(${APP_NAME})
add_subdirectory(src)

# Include directories
include_directories(${NumPy_INCLUDE_DIRS})
target_include_directories(${APP_NAME}
  PRIVATE
    ${Python_INCLUDE_DIRS}
    ${NumPy_INCLUDE_DIRS}
    ${MATPLOTLIB_PATH}
)

# Link libraries
target_link_libraries(${APP_NAME}
  PRIVATE
    Python::Python
)

# Preprocessor definitions
if(WIN32)
  target_compile_definitions(${APP_NAME}
    PRIVATE
      UNICODE
      _UNICODE
      PYTHON_EXE_PATH="${CMAKE_SOURCE_DIR}/venv/Scripts/python.exe"
      PYTHON_PACKAGE_DIR="${CMAKE_SOURCE_DIR}/venv/Lib/site-packages"
  )
elseif(APPLE OR UNIX)
  target_compile_definitions(${APP_NAME}
    PRIVATE
      PYTHON_EXE_PATH="${CMAKE_SOURCE_DIR}/venv/bin/python3"
      PYTHON_PACKAGE_DIR="${CMAKE_SOURCE_DIR}/venv/lib/python${Python_VERSION_WITH_DOT}/site-packages"
  )
else()
  message(STATUS "Unknown platform.")
endif()

# Compiler options (platform-specific)
if(MSVC)
  set(CMAKE_CXX_FLAGS_RELEASE "/MD")
  set(CMAKE_CXX_FLAGS_DEBUG "/MDd")
  add_compile_options(/MP)
  target_compile_options(${APP_NAME}
  PRIVATE 
    /W4
    /EHsc
  )
else()
  target_compile_options(${APP_NAME}
    PRIVATE
      -Wall
      -Wextra
      -fexceptions
  )
endif()

# Set executable name
set_target_properties(${APP_NAME} PROPERTIES OUTPUT_NAME ${APP_NAME})