  all: build 404s
  
  build:
    ./build.sh
  
  404s:
    wget --spider -r -p https://requestpolicycontinued.github.io/ 2>&1 | grep -B 2 ' 404 '
