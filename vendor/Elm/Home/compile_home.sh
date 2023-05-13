#!/bin/bash

elm make ./src/Main.elm --output home.js


mkdir -p ../../../app/javascript/plugins
mv ./home.js ../../../app/javascript/plugins/home.js
