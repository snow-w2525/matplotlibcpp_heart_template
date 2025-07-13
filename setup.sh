#!/bin/bash

set -e

# ================================
# Create Python virtual environment
# ================================
echo "=== Create Python virtual environment ==="
python3 -m venv venv
source ./venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install numpy matplotlib
NumPy_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())")
deactivate

# ================================
# Set Python-related variables
# ================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Python_EXECUTABLE="$SCRIPT_DIR/venv/bin/python3"
Python_PACKAGE_DIR="$SCRIPT_DIR/venv/lib/python3*/site-packages"

Python_VERSION_WITH_SUBMINOR=$($Python_EXECUTABLE --version | awk '{print $2}')
MAJOR=$(echo "$Python_VERSION_WITH_SUBMINOR" | cut -d. -f1)
MINOR=$(echo "$Python_VERSION_WITH_SUBMINOR" | cut -d. -f2)
Python_VERSION="${MAJOR}${MINOR}"
Python_VERSION_WITH_DOT="${MAJOR}.${MINOR}"

PYTHON_DEV_DIR=$(dirname $(dirname $(which python3)))
Python_INCLUDE_DIRS="$PYTHON_DEV_DIR/include/python${MAJOR}.${MINOR}"
Python_LIBRARIES="$PYTHON_DEV_DIR/lib/libpython${MAJOR}.${MINOR}.a"  # use .so or .dylib if preferred

# ================================
# CMake with Ninja
# ================================
BUILD_PATH="$SCRIPT_DIR/build/ninja"

echo "=== Building with Ninja ==="
echo "BUILD_PATH: $BUILD_PATH"
echo "Python_EXECUTABLE: $Python_EXECUTABLE"
echo "Python_LIBRARIES: $Python_LIBRARIES"
echo "Python_INCLUDE_DIRS: $Python_INCLUDE_DIRS"
echo "NumPy_INCLUDE_DIRS: $NumPy_INCLUDE_DIRS"
echo "Python_VERSION: $Python_VERSION"
echo "Python_VERSION_WITH_DOT: $Python_VERSION_WITH_DOT"

cmake -S . -B "$BUILD_PATH" \
    -G "Ninja" \
    -DCMAKE_BUILD_TYPE=Release \
    -D Python_EXECUTABLE="$Python_EXECUTABLE" \
    -D Python_LIBRARIES="$Python_LIBRARIES" \
    -D Python_INCLUDE_DIRS="$Python_INCLUDE_DIRS" \
    -D Python_PACKAGE_DIR="$Python_PACKAGE_DIR" \
    -D Python_VERSION_WITH_DOT="$Python_VERSION_WITH_DOT" \
    -D NumPy_INCLUDE_DIRS="$NumPy_INCLUDE_DIRS"

echo "To build the project, run: ninja -C $BUILD_PATH"