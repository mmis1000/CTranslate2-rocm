# === settings ==-

# find the correct ROCm path for your architecture at https://github.com/ROCm/TheRock/blob/main/RELEASES.md#index-page-listing
# $SEED_ROCM_PATH="https://rocm.nightlies.amd.com/v2/gfx120X-all/"
$SEED_ROCM_PATH=""

# find the correct GPU architecture for your GPU at https://rocm.docs.amd.com/en/latest/reference/gpu-arch-specs.html
# $SEED_PYTORCH_ROCM_ARCH="gfx1201"
$SEED_PYTORCH_ROCM_ARCH=""
# === script start ===

if ($SEED_ROCM_PATH -eq "") {
    Write-Error "Please set SEED_ROCM_PATH variable in the script."
    exit 1
}

if ($SEED_PYTORCH_ROCM_ARCH -eq "") {
    Write-Error "Please set SEED_PYTORCH_ROCM_ARCH variable in the script."
    exit 1
}

$env:PYTORCH_ROCM_ARCH=$SEED_PYTORCH_ROCM_ARCH

Set-Location \
mkdir playground
Set-Location \playground

$env:VSLANG="1033"
Set-ExecutionPolicy Bypass -scope Process -Force

(New-Object Net.WebClient).DownloadFile("https://registrationcenter-download.intel.com/akdlm/IRC_NAS/f5881e61-dcdc-40f1-9bd9-717081ac623c/intel-oneapi-base-toolkit-2025.2.1.46_offline.exe", "$(Get-Location)\oneapi-installer.exe")
# .\oneapi-installer.exe -a --silent --eula accept
# Start-Process "$(pwd)\oneapi-installer.exe" -ArgumentList "-a","--silent","--eula","accept" -NoNewWindow -Wait
Measure-Command {
  Start-Process "$(Get-Location)\oneapi-installer.exe" -ArgumentList "-a","--silent","--eula","accept","-p=NEED_VS2022_INTEGRATION=0" -NoNewWindow -Wait | Out-Default
}

(New-Object Net.WebClient).DownloadFile("https://aka.ms/vs/17/release/vs_buildtools.exe", "$(Get-Location)\vs_buildtools.exe")
# .\vs_buildtools.exe  --passive --wait --channelId "VisualStudio.17.Release" --add "Microsoft.VisualStudio.Workload.VCTools;includeRecommended" --add "Microsoft.VisualStudio.Component.VC.ATL"
# Start-Process "$(pwd)\vs_buildtools.exe" -ArgumentList "--passive","--wait","--channelId","VisualStudio.17.Release","--add","Microsoft.VisualStudio.Workload.VCTools;includeRecommended","--add","Microsoft.VisualStudio.Component.VC.ATL" -NoNewWindow -Wait

Measure-Command {
  Start-Process "$(Get-Location)\vs_buildtools.exe" -ArgumentList "--passive","--wait","--addProductLang","En-us","--channelId","VisualStudio.17.Release","--add","Microsoft.VisualStudio.Workload.VCTools;includeRecommended","--add","Microsoft.VisualStudio.Component.VC.ATL" -NoNewWindow -Wait | Out-Default
}

winget install --id Git.Git -e --source winget
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/0.9.4/install.ps1 | iex"

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

# setup rocm sdk environment
mkdir rocm
Set-Location rocm
uv python pin 3.12
uv venv --seed
.venv\scripts\activate
pip install `
  --index-url "$SEED_ROCM_PATH" `
  "rocm[libraries,devel]"
rocm-sdk init

$env:ROCM_PATH=$(rocm-sdk path --root)
Set-Location ..\

# setup project
git clone -b rocm-7-w-window https://github.com/mmis1000/CTranslate2-rocm.git --recurse-submodules

Set-Location CTranslate2-rocm\

.\scripts_windows\prepare.ps1
.\scripts_windows\configure.ps1
.\scripts_windows\build.ps1

# setup wheel build environment
Set-Location python
uv python pin 3.12
uv venv --seed
.venv\scripts\activate
pip install -r install_requirements.txt
Set-Location ../

.\scripts_windows\build-wheel.ps1

Get-ChildItem .\python\dist\