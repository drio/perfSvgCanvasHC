#!/bin/bash

echo "Building!"
sass styles/main.sass:styles/css/main.css
cat styles/css/svg.css >> styles/css/main.css
./node_modules/.bin/coffee --compile --output coffee/js  coffee/

cat \
  ./js/entry.js \
  ./coffee/js/canvas-lchart.js \
  ./coffee/js/data.js \
  ./js/hc-lchart.js \
  ./js/dual-lchart.js \
  ./js/fps.js \
  ./coffee/js/main.js > ./app.js
