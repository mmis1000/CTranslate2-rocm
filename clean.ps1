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