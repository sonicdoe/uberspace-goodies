#!/usr/bin/env sh

# Copyright (c) 2013 Jakob Krigovsky
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Default settings
BACKUP_DIR=~/uberspace-backups/
SSH_CONFIG=~/.ssh/config
ARCHIVE=false
DATE=`date +%d-%m-%Y`

read_hosts() {
	while read line; do
		if [[ $line == Host\ * ]]; then
			CURRENT_HOST="${line:5}"
		fi

		if [[ $line == HostName\ *.uberspace.de ]]; then
			UNIQUE=true

			for HOSTNAME in $HOSTNAMES; do
				if [[ $HOSTNAME == ${line:9} ]]; then
					UNIQUE=false

					break
				fi
			done

			# If there are multiple hosts with the same hostname we only backup the
			# first one.
			if $UNIQUE; then
				HOSTNAMES=("${HOSTNAMES[@]} ${line:9}")
				HOSTS=("${HOSTS[@]} $CURRENT_HOST")
			fi
		fi
	done < "$SSH_CONFIG"
}

run_backup() {
	for HOST in $HOSTS; do
		UBERSPACE=$(ssh $HOST whoami)
		
		# Remove trailing slash, if any.
		BACKUP_DIR=${BACKUP_DIR%/}

		echo "Uberspace: $UBERSPACE\n"

		if  $ARCHIVE; then
			# Create a tar.bz2-archive
			mkdir -p "${BACKUP_DIR}/archives/"			
			echo "• Backing up /home/$UBERSPACE"
			ssh $HOST "tar -cjf - /home/$UBERSPACE" >${BACKUP_DIR}/archives/uberspace-$UBERSPACE-home-$DATE.tar.bz2 && echo "✔ Backed up /home/$UBERSPACE → uberspace-$UBERSPACE-home-$DATE.tar.bz2"
		else
			# Sync with rsync
			echo "• Syncing /home/$UBERSPACE"
			mkdir -p "${BACKUP_DIR}/home/$UBERSPACE/"
			rsync -aPz --delete $HOST:/home/$UBERSPACE/ "${BACKUP_DIR}/home/$UBERSPACE/" && echo "✔ Synced /home/$UBERSPACE"
		fi

		if  $ARCHIVE; then
			# Create a tar.bz2-archive
			mkdir -p "${BACKUP_DIR}/archives/"			
			echo "• Backing up /var/www/virtual/$UBERSPACE"
			ssh $HOST "tar -cjf - /var/www/virtual/$UBERSPACE" >${BACKUP_DIR}/archives/uberspace-$UBERSPACE-var-$DATE.tar.bz2 && echo "✔ Backed up /var/www/virtual/$UBERSPACE → uberspace-$UBERSPACE-var-$DATE.tar.bz2"
		else
			# Sync with rsync		
			echo "• Syncing /var/www/virtual/$UBERSPACE"
			mkdir -p "${BACKUP_DIR}/var/www/virtual/$UBERSPACE/"
			rsync -aPz --delete $HOST:/var/www/virtual/$UBERSPACE/ "${BACKUP_DIR}/var/www/virtual/$UBERSPACE/" && echo "✔ Synced /var/www/virtual/$UBERSPACE"
		fi

		echo "• Dumping MySQL databases"
		mkdir -p "${BACKUP_DIR}/mysqlbackup/$UBERSPACE/"
		ssh $HOST "mysqldump --compact --comments --dump-date --quick --all-databases | xz" > "${BACKUP_DIR}/mysqlbackup/$UBERSPACE/all-databases.sql.xz" && echo "✔ Dumped MySQL databases"

		echo
	done
}

on_sigint() {
	echo "Received SIGINT."
	exit 1
}

while getopts ab:h:s: option; do
	case "$option" in
	a)
		ARCHIVE=true ;;
	b)
		BACKUP_DIR=$OPTARG ;;
	h)
		HOSTS=("${HOSTS[@]} $OPTARG") ;;
	s)
		SSH_CONFIG=$OPTARG ;;
	esac
done

trap on_sigint SIGINT

# Only read hosts from ssh’s config if none were specified using -h
if [ -z "$HOSTS" ]; then
	read_hosts
fi

run_backup
