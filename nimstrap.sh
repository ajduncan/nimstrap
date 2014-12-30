#!/bin/sh

NIMSTRAP_DIR="$( cd "$( dirname "$0" )" && pwd )"

echo "
########################################################################
 _   _ _               _                   
| \ | (_)_ __ ___  ___| |_ _ __ __ _ _ __  
|  \| | | '_ ' _ \/ __| __| '__/ _' | '_ \ 
| |\  | | | | | | \__ \ |_| | | (_| | |_) |
|_| \_|_|_| |_| |_|___/\__|_|  \__,_| .__/ 
                                    |_|    

########################################################################

"

echo "Cloning Nim repository..."
git clone -b master git://github.com/Araq/Nim.git > /dev/null 2>&1
cd $NIMSTRAP_DIR/Nim
git clone -b master --depth 1 git://github.com/nim-lang/csources > /dev/null 2>&1

echo "Building nim..."
cd $NIMSTRAP_DIR/Nim/csources && sh build.sh > /dev/null 2>&1
cd $NIMSTRAP_DIR/Nim
$NIMSTRAP_DIR/Nim/bin/nim c koch > /dev/null 2>&1
$NIMSTRAP_DIR/Nim/koch boot -d:release > /dev/null 2>&1
cd $NIMSTRAP_DIR

echo "Finished building nim."

if [ -x $NIMSTRAP_DIR/Nim/bin/nim ]; then
    $NIMSTRAP_DIR/Nim/bin/nim c $NIMSTRAP_DIR/hello.nim > /dev/null 2>&1
    if [ -x $NIMSTRAP_DIR/hello ]; then
        $NIMSTRAP_DIR/hello
        exit 0
    else
        echo "Error compiling hello.nim."
        exit 1
    fi
else
    echo "Error building nim."
    exit 1
fi
