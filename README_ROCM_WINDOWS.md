# ROCm CT2

<div align="center">

[Upstream README](README.md) | **ROCm Install Guide**
</div>

## Install Guide

This is a guide to build ctranslate2-rocm on a Windows machine. Currently, the only ROCm version on Windows that contains MIOPEN is ROCm 7, which is under heavy development, so usability is not guaranteed.

## Tweaks

1. Some slight tweaks have been made to the files to support name and header changes in ROCm 7.
2. The `CMakeLists.txt` have been edited to fix the incorrect assumption of `windows always use msvc to compile projects`

## Dependencies

1. Windows Build Tools 2022

   Use the installer for `Build Tools for Visual Studio 2022` from https://visualstudio.microsoft.com/zh-hant/downloads/ to install C++ components and the first 7 optional subcomponents. `ATL` needs to be selected because it is used by setuptools.

   **WARNING: Untick any other language and select only the English language pack if you are on a non-English system, or the build will always fail with mysterious error messages.**

2. oneDNN and mkl
   
   Get one DNN from here: https://www.intel.com/content/www/us/en/developer/tools/oneapi/onednn-download.html

   Get mkl from here: https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html


3. ROCm 7 preview
   1. Create a venv somewhere.
   2. Install the package that matches your card from https://github.com/ROCm/TheRock/blob/main/RELEASES.md
   3. Open an admin shell and run `rocm-sdk init`.
   4. **Fix the permissions of `.venv\Lib\site-packages\_rocm_sdk_libraries_{{YOUR_CPU_ARC}}_all` using `takeown` or GUI methods. Steps can be found online.**
   5. Get the installation path with `rocm-sdk.exe path --root`; this will be used later.

   Note: Running `rocm-sdk init` in an admin shell breaks the read permission of the SDK folder. This needs to be fixed or the build won't work.

4. Python 

   Install it in any way you prefer.

## Steps

All scripts below assume PowerShell.

## Clean previous built result

1. Run `.\clean.ps1` to clear all builds when switching config.

## Configure environment

This step needs to be run before running any other steps.
The effect is temporary and will be lost after closing the terminal.

1. Edit `prepare.ps1`, change the `VS_BUILD_TOOLS_ROOT`, `ROCM_PATH`, `PYTORCH_ROCM_ARCH`, and `INTEL_ROOT` to match your actual install paths.
2. Run `.\prepare.ps1` to configure the current shell environment.

## Build ctranslate2
1. Run `.\configure.ps1` to configure the build.

   - or `.\configure-no-rocm.ps1` to compile without rocm and hip
   - or `.\configure-msvc.ps1` to compile without rocm and hip and with msvc
2. Run `.\build.ps1` to build the actual dist.

## Build the python wheel
1. Switch to the `.\python` directory.
2. Activate the `venv` and install Python dependencies with `pip install -r install_requirements.txt`.
3. Run `.\prepare.ps1` to configure the environment again because `venv` wiped the PATH.
4. Run `python setup.py bdist_wheel` to build the Python wheel.

## Debug not found runtime errors

1. Use https://github.com/lucasg/Dependencies to find which DLLs are missing.

## Test and benchmark

The rest of the instructions are the same as the [steps for Linux](./README_ROCM.md)