#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied - Needs arm32 source file and IP of compile server"
fi

DIR="arm_build_server"

if [ ! -d "build" ]
then
	mkdir build
fi

# FOLDER STRUCT ON HOST
# == /usr/bin/
# ==== /arm_build_server

# Move source file to compile server
sshpass -p 'asm' scp $1 asm@pet:/usr/bin/$DIR/

# Assemble and link source file
sshpass -p 'asm' ssh asm@pet "arm-linux-gnueabihf-as -g -o /usr/bin/arm_build_server/peachykeen32.o /usr/bin/arm_build_server/m_peachykeen32.s"
sshpass -p 'asm' ssh asm@pet "arm-linux-gnueabihf-ld -o /usr/bin/arm_build_server/peachykeen32 /usr/bin/arm_build_server/peachykeen32.o -Ttext=0x10000 --no-dynamic-linker -nostdlib"

# Move compiled files back
sshpass -p 'asm' scp asm@pet:/usr/bin/$DIR/* build

# Clean
sshpass -p 'asm' ssh asm@pet "rm -rf /usr/bin/$DIR/*" 
