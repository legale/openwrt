#!/bin/sh

make -j$(nproc) $2
./deploy.sh
./deploywda.sh


