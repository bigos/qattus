#!/bin/bash

elm make ./src/Main.elm --output home.js
mv ./home.js ../../../app/javascript/plugins/home.js
