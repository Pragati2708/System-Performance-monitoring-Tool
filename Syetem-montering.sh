#!/bin/bash
#Date-27/12/2025
#Maintainer-Pragati
#Description- This script will monitor the system CPU , RAM and storage uses and send alert on gmail.
echo "This script will monitor the system CPU , RAM and storage uses and send alert on gmail."
echo $(date)
#Defining the variables
CPU_THRESHOLD=80
RAM_THRESHOLD=80
STORAGE_THRESHOLD=80
EMAIL="XXXXXXXXXXXX"
APP_PASSCODE="XXXXXXXXX"

#Function for sending mail to gmail via curl
send_mail() {
    subject="$1"
    body="$2"
    curl --ssl-reqd \
        --url "smtps://smtp.gmail.com:465" \
        --user "$EMAIL:$APP_PASSCODE" \
        --mail-from "$EMAIL" \
        --mail-rcpt "$EMAIL" \
        --upload-file <(echo -e "Subject: $subject\n\n$body")
}
#Checking the CPU usage based on current useages and send the alert on mail
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
cpu_usage_init=${cpu_usage%.*}
if (( cpu_usage_init > CPU_THRESHOLD )) ; then
    send_mail "CPU Usage Alert" "CPU usage is above the threshold: $cpu_usage%"
fi
#Checking the RAM usage based on current useages and send the alert on mail
ram_usage=$(free -m | awk '/Mem:/ {print $3/$2 * 100.0}')
ram_usage_init=${ram_usage%.*}
if (( ram_usage_init > RAM_THRESHOLD )) ; then
    send_mail "RAM Usage Alert" "RAM usage is above the threshold: $ram_usage%"
fi
#Checking the Storage usage based on current useages and send the alert on mail
storage_usage=$(df -h / | awk '/\// {print $5}' | tr -d '%')
storage_usage_init=${storage_usage%.*}
if ((storage_usage_init > STORAGE_THRESHOLD )) ; then
     send_mail "Storage Usage Alert" "Storage usage is above the threshold: $storage_usage%"
fi
echo "CPU usage: $cpu_usage%"
echo "RAM usage: $ram_usage%"
echo "Storage usage: $storage_usage%"
echo "Monitoring completed"

