#! /bin/bash




# If designer dir not available, git clone it
if ! [ -d "../designer" ]; then
    (cd ../ && git clone https://github.com/nesign/designer.git)
fi

source "../designer/serve.sh"