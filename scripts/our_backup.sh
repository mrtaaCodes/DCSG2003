#!/bin/bash

#Tar en backup av databasen, og sender en komprimert fil til backup VM
#Kjøres i db1'VM-en og sendes til backup

#Lager filnavn spesefikasjoner
filename="backityupity$(date +"%m-%d-%y")"

#Lager backup og legger dette inn i backity_upity
python3 /home/ubuntu/bookface/tools/backup_db.py --output-dir /home/ubuntu/BACKITY_UPITY/$filename

#Komprimerer filen
tar czf /home/ubuntu/BACKITY_UPITY/$filename.tgz /home/ubuntu/BACKITY_UPITY/$filename

#Secure copy til filen inni backup-VM'en
scp /home/ubuntu/BACKITY_UPITY/$filename.tgz backup:/home/ubuntu/WAKEUP_BACKUP/

#Secure copy til filen inne i volumet i backup-VM'en
scp /home/ubuntu/BACKITY_UPITY/$filename.tgz backup:/mnt/WAKEUP_MAKEUP_BACKUP/

#Fjerner alt innhold i mappen slik at den er tom og klar for en ny backup :)
sudo rm -r /home/ubuntu/BACKITY_UPITY/*
