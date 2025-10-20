Copy-Item "bin/ctranslate2.dll" "python/ctranslate2/"

Set-Location "./python"

.venv/scripts/activate
& "../scripts_windows/prepare.ps1"

python setup.py bdist_wheel

Set-Location ../

.venv/scripts/activate
& "./scripts_windows/prepare.ps1"