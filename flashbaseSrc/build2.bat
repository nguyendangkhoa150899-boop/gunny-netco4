@echo off
call "build.bat"
echo build completed, rename files
::cd lib
mv ./lib/EasyGunny.swc ./lib/flash.zip
tar -xf ./lib/flash.zip -C ./lib