#!/bin/sh

for f in $(ls *.config); do
 echo config $f
 cp $f .config
 ./deploywda.sh
 ./deploy.sh
done
