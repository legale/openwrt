#!/bin/sh

for f in $(ls *.config); do
 echo config $f
 cp $f .config
 make -j$(nproc) $2
 ./deploywda.sh
 ./deploy.sh
done
