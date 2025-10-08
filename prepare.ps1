# Set UTF-8 code page, or build will fail with error
chcp 65001

# CHANGE THIS to your VSCODE Build Tools path
$VS_BUILD_TOOLS_ROOT="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
# CHANGE THIS to your ROCm SDK path
$env:ROCM_PATH = "M:\Playground\Rocm\.venv\Lib\site-packages\_rocm_sdk_devel"
# CHANGE THIS to your GPU architecture
$env:PYTORCH_ROCM_ARCH="gfx1201"
# CHANGE THIS to your Intel oneAPI path
$env:INTEL_ROOT="C:\Program Files (x86)\Intel\oneAPI"

$env:CTRANSLATE2_ROOT = "$PSScriptRoot"

& "$VS_BUILD_TOOLS_ROOT\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64

$env:PATH="$env:ROCM_PATH\bin;$env:PATH"
$env:PATH="$env:CTRANSLATE2_ROOT\bin;$env:PATH"
$env:PATH="$env:CTRANSLATE2_ROOT\build\bin;$env:PATH"

# intel oneapi tools and libraries
# read all folders under intel root, append latest\bin folders to path
Get-ChildItem -Directory "$env:INTEL_ROOT" | ForEach-Object {
    $subDir = $_.FullName
    $latestDir = Join-Path $subDir "latest"
    if (Test-Path $latestDir) {
        $binDir = Join-Path $latestDir "bin"
        if (Test-Path $binDir) {
            $env:PATH="$binDir;$env:PATH"
        }
    }
}

# variables for clang
$env:CC="$env:ROCM_PATH\lib\llvm\bin\clang.exe"
$env:CXX="$env:ROCM_PATH\lib\llvm\bin\clang++.exe"

# variables for hip
$env:HIP_PLATFORM = "amd" 
$env:HIP_PATH = "$env:ROCM_PATH"
$env:HIP_DEVICE_LIB_PATH="$env:ROCM_PATH\lib\llvm\amdgcn\bitcode"
$env:HIP_CLANG_ROOT="$env:ROCM_PATH\lib\llvm\"