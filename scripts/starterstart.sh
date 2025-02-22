#!/bin/bash

#Dette skriptet er for å starte alle VM'er som er kobla til manager - dersom de er nede
#Scriptet er i manager

#Henter RC filen som er i manager. VIKTIG!
source DCSG2003_V25_group53-openrc.sh

# Henter en liste av alle servere som er nede
shutoff_vm=$(openstack server list --status SHUTOFF -f value -c ID)

# Sjekker om noen servere er nede
if [ -z "$shutoff_vm" ]; then
    echo "No shutoff servers found."
    exit 0
fi

# Starter VM'ene som er nede
for vm_id in $shutoff_vm; do
    echo "Starter vm: $vm_id"
    openstack server start "$vm_id"
done

echo "Alle VM'er som er nede er nå oppe"
