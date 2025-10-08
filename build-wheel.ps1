Copy-Item "$env:CTRANSLATE2_ROOT/bin/ctranslate2.dll" "$env:CTRANSLATE2_ROOT/python/ctranslate2/"

Set-Location python

.venv/scripts/activate
Set-Location ..
& "./prepare.ps1"
Set-Location python

python setup.py bdist_wheel

Set-Location ../

.venv/scripts/activate
& "./prepare.ps1"