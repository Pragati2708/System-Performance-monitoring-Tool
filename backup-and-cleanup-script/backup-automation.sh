#!/bin/bash
# Date-27/12/2025
# Maintainer-Pragati
#
# Description- This script will automate the backup of files and folders to a specified location.
echo "This script will automate the backup of files and folders to a specified location."
path=$1
echo "The path of the file or folder to be backed up is: $path"
backup_file="${path}_$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$backup_file" "$path"
echo "Backup of $path completed successfully. Backup file: $backup_file"

#Identify and clean files older than a defined number of days and Maintain a log file with timestamps
if [ -z "$DIR" ]; then
  echo "Usage: $0 <source_dir> [days_old]"
  exit 1
fi

find "$DIR" -type f -mtime +$DAYS_OLD -name "*.tar.gz" \
-exec sh -c 'rm "$1"; echo "Deleted $1 on $(date)" >> backup_cleanup.log' _ {} \;
