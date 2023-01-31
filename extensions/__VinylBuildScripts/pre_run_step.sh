#!/bin/bash

openssl base64 -in "$YYprojectDir/notes/__VinylConfig/__VinylConfig.txt" -out "$YYprojectDir/datafiles/vinyl.dat"
cp "$YYprojectDir/notes/__VinylConfig/__VinylConfig.txt" "$YYprojectDir/datafiles/vinyl.json"

exit 0