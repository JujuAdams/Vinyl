#!/bin/bash

openssl base64 -in "$YYprojectDir/notes/__VinylConfig/__VinylConfig.txt" -out "$YYprojectDir/datafiles/vinyl.dat"

exit 0