#!/bin/sh
id=$1
sed "s/_ID_/$id/g" pw.yml > pw_${id}.yml 
mkdir -p /data/bimax/pw${id}
rsync -avz /data/bimax/pw/* /data/bimax/pw${id}/
mkdir -p /data/bimax/pw${id}/log
chmod 777 -R /data/bimax/pw${id}/log
