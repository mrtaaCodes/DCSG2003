#!/bin/bash


## OLD SCRIPT FOR STATUS - LUNA LUX ##



# Associative array mapping VM names to their URLs/IPs
declare -A VMS=(
    ["www1"]="http://192.168.129.66"
    ["www2"]="http://192.168.129.2"
    ["db1"]="http://192.168.130.42"
    ["balancer"]="http://10.212.168.15"
    ["docker"]="http://192.168.133.82"
    ["backup"]="http://192.168.132.210"
    ["quack1"]="http://192.168.132.81"
    ["quack2"]="http://192.168.132.144"
    ["quack3"]="http://192.168.128.215"
)
#Discord webhook
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1331565381135106058/27TQ_RlEOwwwDgyJgA0tPYtlyXmT72iJUYPVMVD94ev_JccmNALE3r4lFFqJmxgAip6O"


#function to notify discord
send_discord_notification() {
    VM_NAME="$1"  # First argument is the VM name
    VM_URL="$2"   # Second argument is the VM URL
    STATUS="$3"   # Third argument is the VM status

    # Message content to send to Discord
    MESSAGE="🚨 **HELLO!?** My followers can't see MY posts!?!?!?\\n     \\nVM **$VM_NAME** at $VM_URL is $STATUS! @everyone\\n\\n\\nCAN YOU HEAR ME??!\\n\\nFIX.\\n\\nIT.\\n\\nNOW.😡😡😡\\n-\\n-\\n-\\nhttps://tenor.com/view/smh-kermit-kermit-the-frog-muppet-muppets-gif-467850616214781464"

    # Use curl to send the notification to Discord
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"$MESSAGE\"}" \
         $DISCORD_WEBHOOK_URL
}

# Header for the table
echo "=============================================="
printf "%-15s %-20s %-10s\n" "VM Name" "VM URL"    "STATUS"
echo "=============================================="

# Check each VM's status
for VM_NAME in "${!VMS[@]}"; do
    VM_URL="${VMS[$VM_NAME]}"

    # Use curl to check if the VM responds (timeout is 3 seconds)
    if curl -s --head --request GET "$VM_URL" --connect-timeout 3 | grep "200 OK" > /dev/null; then
        STATUS="ACTIVE"
    else
        STATUS="INACTIVE"

        # Send Discord notification if the VM is inactive
        send_discord_notification "$VM_NAME" "$VM_URL" "$STATUS"
    fi

    # Print the status in a formatted table
    printf "%-15s %-20s %-10s\n" "$VM_NAME" "$VM_URL" "$STATUS"
done

echo "==========================================="
