#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied - Needs arm32 source file and IP of compile server"
fi

SOURCE_F = $1
HOST_IP  = $2
DIR 	 = "arm_build_server"

if [ ! -d "build" ]
then
	mkdir build
fi

# FOLDER STRUCT ON HOST
# == /usr/bin/
# ==== /arm_build_server

# Move source file to compile server
scp $SOURCE_F root@HOST_IP:/usr/bin/$DIR/

# Assemble and link source file
ssh root@HOST_IP "arm-linux-gnueabihf-as -g -o peachykeen32.o m_peachykeen32.s"
ssh root@HOST_IP "arm-linux-gnueabihf-ld -o peachykeen32 peachykeen32.o -Ttext=0x10000 --no-dynamic-linker -nostdlib"

# Move compiled files back
scp root@HOST_IP:/usr/bin/$DIR/* build

# Clean
ssh root@HOST_IP "rm -rf /usr/bin/$DIR/*" 
