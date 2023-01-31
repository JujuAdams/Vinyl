@echo off
"%YYprojectDir%\extensions\__VinylBuildScripts\base64.exe" /e "%YYprojectDir%\notes\__VinylConfig\__VinylConfig.txt" "%YYprojectDir%\datafiles\vinyl.dat"
copy /y "%YYprojectDir%\notes\__VinylConfig\__VinylConfig.txt" "%YYprojectDir%\datafiles\vinyl.json"