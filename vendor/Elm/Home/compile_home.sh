#!/bin/bash

elm make ./src/Main.elm --output home.js


# mkdir -p ../../../app/javascript/plugins
# cp ./home.js ../../../app/javascript/plugins/home.js

mv ./home.js ../../../app/assets/javascript/plugins/home.js
