@echo off
setlocal

rem ================================
rem Create Python virtual environment
rem ================================
python -m venv venv
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
python -m pip install numpy
for /f "delims=" %%i in ('python -c "import numpy; print(numpy.get_include())"') do (
    set "NumPy_INCLUDE_DIRS=%%i"
)
python -m pip install matplotlib
call venv\Scripts\deactivate.bat

rem ================================
rem Set Python-related variables
rem ================================
set Python_EXECUTABLE=%~dp0venv\Scripts\python.exe
set Python_PACKAGE_DIR=%~dp0venv\Lib\site-packages

for /f "delims=" %%i in ('where python') do (
    set PYTHON_DEV_PATH=%%i
    goto :got_python
)
:got_python
for %%i in ("%PYTHON_DEV_PATH%") do (
    set PYTHON_DEV_DIR=%%~dpi
)

for /f "tokens=2 delims= " %%i in ('%PYTHON_EXECUTABLE% --version') do (
    set Python_VERSION_WITH_SUBMINOR=%%i
)

for /f "tokens=1,2 delims=." %%A in ("%Python_VERSION_WITH_SUBMINOR%") do (
    set MAJOR=%%A
    set MINOR=%%B
)
set Python_VERSION=%MAJOR%%MINOR%

set Python_INCLUDE_DIRS=%PYTHON_DEV_DIR%include
set Python_LIBRARIES=%PYTHON_DEV_DIR%libs\python%Python_VERSION%.lib

rem ================================
rem CMake with Ninja
rem ================================
set BUILD_PATH=%~dp0build\ninja

echo Building with Ninja...
echo BUILD_PATH=%BUILD_PATH%
echo Python_EXECUTABLE=%Python_EXECUTABLE%
echo Python_LIBRARIES=%Python_LIBRARIES%
echo Python_INCLUDE_DIRS=%Python_INCLUDE_DIRS%
echo NumPy_INCLUDE_DIRS=%NumPy_INCLUDE_DIRS%
echo Python_VERSION=%Python_VERSION%

pause

rem Run CMake with Ninja generator
cmake -S . -B "%BUILD_PATH%" ^
    -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -D Python_EXECUTABLE=%Python_EXECUTABLE% ^
    -D Python_LIBRARIES=%Python_LIBRARIES% ^
    -D Python_INCLUDE_DIRS=%Python_INCLUDE_DIRS% ^
    -D Python_PACKAGE_DIR=%Python_PACKAGE_DIR% ^
    -D NumPy_INCLUDE_DIRS=%NumPy_INCLUDE_DIRS%

echo "To build the project, run: ninja -C $BUILD_PATH"