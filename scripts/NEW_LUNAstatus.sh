#!/bin/bash

# Associative array mapping VM names to their IPs
declare -A VMS=(
    ["www1"]="192.168.129.66"
    ["www2"]="192.168.129.2"
    ["db1"]="192.168.130.42"
    ["balancer"]="192.168.131.103"
    ["docker"]="192.168.133.82"
    ["backup"]="192.168.132.210"
    ["quack1"]="192.168.132.81"
    ["quack2"]="192.168.132.144"
    ["quack3"]="192.168.128.215"
    ["TEST"]="192.168.133.102"
)

# Discord webhook URL
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1331565381135106058/27TQ_RlEOwwwDgyJgA0tPYtlyXmT72iJUYPVMVD94ev_JccmNALE3r4lFFqJmxgAip6O"

# Define an array of Tenor GIF URLs
GIFS=(
    "https://tenor.com/view/smh-kermit-kermit-the-frog-muppet-muppets-gif-467850616214781464"
    "https://tenor.com/view/kid-en-sacrement-regard-de-feu-gif-15231722216266444049"
    "https://tenor.com/view/scream-loud-scream-girl-kid-hispanic-girl-gif-3761151244536557927"
    "https://tenor.com/view/cat-side-eye-gif-5016118126108679217"
)

# Function to pick a random GIF URL
get_random_gif() {
    local count=${#GIFS[@]}
    local index=$(( RANDOM % count ))
    echo "${GIFS[$index]}"
}



# Function to send a Discord notification
send_discord_notification() {
    VM_NAME="$1"
    VM_IP="$2"
    STATUS="$3"

   # Get a random GIF URL and assign it to RANDOM_GIF
    RANDOM_GIF=$(get_random_gif)


    MESSAGE="🚨 **HELLO!?** My followers can't see MY posts!?!?!?\\n     \\nVM **$VM_NAME** at $VM_IP is $STATUS! @everyone\\n\\n\\nCAN YOU HEAR ME??!\\n\\nFIX.\\n\\nIT.\\n\\nNOW.😡😡😡\\n-\\n-\\n-\\$RANDOM_GIF"

    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"$MESSAGE\"}" \
         $DISCORD_WEBHOOK_URL
}

# Header for the table
echo "=============================================="
printf "%-15s %-20s %-10s\n" "VM Name" "VM IP" "STATUS"
echo "=============================================="

# Check each VM's status using ping
for VM_NAME in "${!VMS[@]}"; do
    VM_IP="${VMS[$VM_NAME]}"

    # Ping the VM with a single packet and timeout of 3 seconds
    if ping -c 1 -W 3 "$VM_IP" > /dev/null; then
        STATUS="ACTIVE"
    else
        STATUS="INACTIVE"

        # Send Discord notification if the VM is inactive
        send_discord_notification "$VM_NAME" "$VM_IP" "$STATUS"
    fi

    # Print the status in a formatted table
    printf "%-15s %-20s %-10s\n" "$VM_NAME" "$VM_IP" "$STATUS"
done

echo "==========================================="
