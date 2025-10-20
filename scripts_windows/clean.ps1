# abort when attempt to run on root dir
if ("$(pwd)" -eq (Resolve-Path "$(pwd)\..\")) {
    Write-Error "Refusing to run clean.ps1 from root directory"
    exit 1
}

# clean build/ dir 
Remove-Item -Recurse -Force build
# clean bin/ dir 
Remove-Item -Recurse -Force bin
# clean lib/ dir 
Remove-Item -Recurse -Force lib
# clean python/build/
Remove-Item -Recurse -Force python/build
# clean python/dist/
Remove-Item -Recurse -Force python/dist