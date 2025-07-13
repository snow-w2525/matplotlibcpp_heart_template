#define _USE_MATH_DEFINES
#include <iostream>
#include <string>
#include "matplotlibcpp.h"

namespace plt = matplotlibcpp;


static void append_python_packages() {
    std::string s_pthon_exe_path = PYTHON_EXE_PATH;
    std::string s_pthon_package_dir = PYTHON_PACKAGE_DIR;
    std::wstring ws_pthon_exe_path(s_pthon_exe_path.begin(), s_pthon_exe_path.end());
    const wchar_t* python_exe_path = ws_pthon_exe_path.c_str();

    Py_SetProgramName(python_exe_path);
    Py_Initialize();
    PyRun_SimpleString("import sys");
    std::string s_append_python_package_dir
        = "sys.path.append('" + s_pthon_package_dir + "')";
    PyRun_SimpleString(s_append_python_package_dir.c_str());
}

static void draw_heart() {
    std::vector<double> x, y;

    for (double t = 0.0; t <= 2 * M_PI; t += 0.01) {
        x.push_back(16 * pow(sin(t), 3));
        y.push_back(13 * cos(t) - 5 * cos(2*t) - 2 * cos(3*t) - cos(4*t));
    }

    plt::plot(x, y, "r"); 
    plt::title("♥ Heart with matplotlib-cpp ♥");
    plt::axis("equal");
    plt::show();

}

int main(){
    
    append_python_packages();
    draw_heart();
    return 0;
    
}