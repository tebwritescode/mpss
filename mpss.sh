#!/bin/bash
#MPSS - Mount Point Service Sync
# Disables/Enables plexmediaserver, tdarr_node service based on the existance of
# a file on the network share

FILE="/path/to/mount/MOUNT_POINT_ALIVE" #The location of the file on the share
SERVICE="service" #Service that can be started/stopped with systemctl
LOG_FILE="/var/log/mpss.log" #Where to save the log
MAX_LINES=200 #How many lines of logs to keep in the log file

# Get the current number of lines in the log file
CURRENT_LINES=$(wc -l < "$LOG_FILE")

# If there are more than MAX_LINES, truncate the file to keep only the last MAX_LINES lines
if [ $CURRENT_LINES -gt $MAX_LINES ]; then
    echo "$(date) INFO: MPSS: Trimming log file"
    tail -n $MAX_LINES $LOG_FILE >> mpss-temp.log
    mv mpss-temp.log "$LOG_FILE"
fi

sudo mount -a >> /var/log/mpss.log 2>&1

if [ -e "${FILE}" ]; then
    # Start the service if the file exists
    echo "$(date) INFO: MPSS: ${FILE} found! Checking if ${SERVICE} is active and if it isn't starting it." >> /var/log/mpss.log 2>&1
    sudo systemctl is-active --quiet $SERVICE >> /var/log/mpss.log 2>&1 || systemctl start $SERVICE >> /var/log/mpss.log 2>&1
else
    # Stop the service if the file does not exist
    echo "$(date) INFO: MPSS: ${FILE} not found! Checking if ${SERVICE} is active and if it is stopping it." >> /var/log/mpss.log 2>&1
    sudo systemctl is-active --quiet $SERVICE >> /var/log/mpss.log 2>&1 && systemctl stop $SERVICE >> /var/log/mpss.log 2>&1
fi
