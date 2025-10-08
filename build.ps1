Set-Location build
cmake --build . --config Release --target install --parallel 16 --verbose
Set-Location ../