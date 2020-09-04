#!/usr/bin/env bash

#
# You can use this script to make backup copy of simple Zabbix instance.
# As result you'll get a tar archive includes database dump, config and scripts directories.
# For database backup it uses mysqldump or Percona Xtrabackup utility (you must install it previously).
# At least it can compress tar file with one of  popular compression utilities.
# After a few tests I recommend to use lbzip2.
# Have fun and check my repo on github for new versions:
# https://github.com/asand3r/zbx-backup
#

VERSION="0.6.3"

# Current timestamp
TIMESTAMP=$(date +%d.%m.%Y.%H%M%S)

# The function just print help message
function PrintHelpMessage() {
echo "
zbx-backup, version: $VERSION
(c) Khatsayuk Alexander, 2018
Usage:
-b|--backup-with	- utility to make DB dump: mysqldump, xtrabackup
-a|--add-to-backup	- add list of catalogs to backup
-s|--save-to		- location to save result archive file (default: current directory)
-t|--temp-folder	- temp folder where will be placed database dump (default: /tmp)
-c|--compress-with	- compression utility to use with tar: gzip|bzip2|lbzip2|pbzip2|xz
-r|--rotation		- set copies count what we will save (default: 10, set 'no' if rotation needn't)
-h|--db-host		- database host name to connect
-u|--db-user		- username for connection to zabbix database (must be 'root' for xtrabackup)
-p|--db-password	- password for database user; also can be path to file with password or '-' for prompt
-d|--db-name		- database name (default: 'zabbix')
-e|--exclude-tables	- list of database tables to exclude from backup (has two presets: 'data' and 'config')
--version		- print version number and exit
--help			- print this help message
--db-only		- backing up database only without Zabbix config and script files
--debug			- print result information and exit
--force			- force run, if has any warnings that can be skipped

Examples:
# Making backup of Zabbix database and config files with xtrabackup, compress it with lbzip2:
zbx-backup --compress-with lbzip2 --backup-with xtrabackup --db-user root --db-password P@ssw0rd
# Making backup of Zabbix database and config files with mysqldump using password from file, compress it with lbzip2:
zbx-backup --compress-with gzip --backup-with mysqldump --db-user zabbix --db-password /root/.mysql
# Making backup of Zabbix database only and compress it with xz utility.
zbx-backup -b mysqldump --compress-with xz --db-only -u root -p P@ssw0rd
# Making backup of Zabbux database with all data tables exclusion:
zbx-backup --backup-with mysqldump --db-user root --db-password P@ssw0rd --exclude-tables data --compress-with gzip

Repository on GitHub: https://github.com/asand3r/zbx-backup
"
exit 0
}

# Parsing given arguments
if [[ $# -eq 0 ]]; then PrintHelpMessage; fi

while [[ $# -gt 0 ]]
do
	ARG="$1"
	case "$ARG" in
		"-c"|"--compress-with")
			USE_COMPRESSION="YES"
			case "$2" in
				"gzip"|"bzip2"|"xz"|"lbzip2"|"pbzip2")
					COMPRESS_WITH=$2
					;;
				*)
					echo "Syntax error: [-c|--compress-with] gzip|bzip2|xz|lbzip2|pbzip2"
					exit 1
					;;
			esac
			shift 2
			;;
		"-b"|"--backup-with")
			B_UTIL=$2
			case "$B_UTIL" in
				"mdump"|"mysqldump")
					B_UTIL="mysqldump"
					;;
				"xtra"|"xtrabackup")
					B_UTIL="xtrabackup"
					;;
				*)
					echo "Syntax error: [-b|--backup-with] mdump|mysqldump|xtra|xtrabackup"
					exit 1
					;;
			esac
			shift 2
			;;
		"-t"|"--temp-folder")
			TMP=$2
			if [[ $TMP =~ /$ ]]; then TMP=${TMP%?}; fi
			shift 2
			;;	
		"-s"|"--save-to")
			DEST=$2
			LOGFILE="$DEST/zbx_backup.log"
			if [[ $DEST =~ /$ ]]; then DEST=${DEST%?}; LOGFILE="$DEST/zbx_backup.log"; fi
			shift 2
			;;
		"-h"|"--db-host")
			DB_HOST=$2
			shift 2
			;;
		"-u"|"--db-user")
			DB_USER=$2
			shift 2
			;;
		"-p"|"--db-password")
			DB_PASS=$2
			if [[ -f "$DB_PASS" ]]
			then
				DB_PASS=$(cat "$DB_PASS")
				if [[ $? -eq 1 ]]
				then
					echo "ERROR: Cannot read password from file '$DB_PASS'. Check it permissions."
					exit 1
				fi
			fi
			shift 2
			;;
		"-d"|"--db-name")
			DB_NAME=$2
			shift 2
			;;
		"-e"|"--exclude-tables")
			EXCLUDE_TABLES=$2
			shift 2
			;;
		"-a"|"--add-to-backup")
			ZBX_CATALOGS=$2
			shift 2
			;;
		"-r"|"--rotation")
			ROTATION=$2
			shift 2
			;;
		"--help")
			PrintHelpMessage
			;;
		"--version")
			echo "$VERSION"
			exit 0
			;;
		"--db-only")
			DB_ONLY="YES"
			shift
			;;
		"--debug")
			DEBUG="YES"
			shift
			;;
		"--force")
			FORCE="YES"
			shift
			;;
		*)
			echo "Syntax error! Please, use '--help' to view usage examples."
			exit 1
			;;
	esac
done

# Set defaults if arguments not present
if ! [[ "$TMP" ]]; then TMP="/tmp"; fi
if ! [[ "$DB_NAME" ]]; then DB_NAME="zabbix"; fi
if ! [[ "$DB_HOST" ]]; then DB_HOST="localhost"; fi
if ! [[ "$DEST" ]]; then DEST=$(pwd); LOGFILE="$DEST/zbx_backup.log"; fi
if ! [[ "$ROTATION" ]]; then ROTATION=10; fi
if ! [[ "$ZBX_CATALOGS" ]]; then ZBX_CATALOGS=("/usr/lib/zabbix" "/etc/zabbix"); fi
if [[ "$USE_COMPRESSION" ]] && ! [[ $(command -v "$COMPRESS_WITH") ]]; then echo "ERROR: '$COMPRESS_WITH' utility not found."; exit 1; fi

#
# A lot of checks, trying to make this script more friendly
#

# Check '-b' option is provided
if ! [[ "$B_UTIL"  ]]; then echo "ERROR: You must provide backup utility ('-b')."; exit 1; fi

# Checking TMP and DST directories existing
if ! [[ -d "$TMP" ]]; then if ! mkdir -p $TMP; then echo "ERROR: Cannot create temp directory ($TMP)."; exit 1; fi; fi
if ! [[ -d "$DEST" ]]; then echo "ERROR: $TIMESTAMP : Destination directory doesn't exists." | tee -a "./zbx_backup.log"; exit 1; fi
 
# Enter the password if it equal to '-'
if  [[ "$DB_PASS" == "-" ]]
then
	read -s -p "Please, enter the password for user '$DB_USER': " DB_PASS
	echo -e "\n"
fi

# Check if username is provided
if [[ "$DB_USER" ]]
then
	if [[ "$DB_USER" =~ ^[0-9]|- ]] && ! [[ "$FORCE" ]]
	then
		echo "WARNING: Username '$DB_USER' looks wrong (starts with '-' or digit). Use '--force' if it's OK."
		exit 1
	fi
else
	echo "ERROR: You must provide username to connect to the database ('-u|--db-user')."
	exit 1
fi

#
# End of checks
#

# The function cleans $TMP directory
function TmpClean() {
	if [[ -d "$TMP"  ]]
	then
		rm -rf $TMP/zbx_backup_* 2>>"$LOGFILE"
		return 0
	else
		echo "WARNING: $TIMESTAMP : '$TMP' directory not found." | tee -a "$LOGFILE"
		return 1
	fi
}

# The function makes all backup operations
function BackingUp() {
	# Cleaning TMP
	TmpClean
	# If '--db-only' option not set backing up some catalogs
	if ! [[ "$DB_ONLY" ]]
	then
		# Result TAR file with configs
		ZBX_FILES_TAR=$TMP/zbx_backup_files_${TIMESTAMP}.tar
		if [[ -d ${ZBX_CATALOGS[0]} ]]
		then
			# Making initial files tar archive
			tar cf "$ZBX_FILES_TAR" "${ZBX_CATALOGS[0]}" 2>/dev/null
			# Exit if tar fails
			if [[ $? -eq 2 ]]; then echo "ERROR: You have no permission to save '${ZBX_CATALOGS[0]}'"; exit 1; fi
			# Add other catalogs to archive
			for (( i=1; i < ${#ZBX_CATALOGS[@]}; i++ ))
			do
				if [[ -d ${ZBX_CATALOGS[$i]} ]]
				then
					tar -rf "$ZBX_FILES_TAR" "${ZBX_CATALOGS[$i]}" 2>/dev/null
					if [[ $? -eq 2 ]]; then echo "ERROR: Cannot add '${ZBX_CATALOGS[$i]}' to the archive."; exit 1; fi
				else
					echo "WARNING: $TIMESTAMP : Cannot find '${ZBX_CATALOGS[$i]}' to save it." >> "$LOGFILE"
				fi
			done
		else
			echo "ERROR: Cannot create TAR archive '$ZBX_FILES_TAR'." | tee -a "$LOGFILE"
		fi
	fi
	
	# Filter to grep Zabbix table. Uses to form data and config tables arrays.
	ZBX_TABLES_FILTER="^(history|acknowledges|alerts|auditlog|events|trends)"
	
	# Backing up database
	case "$B_UTIL" in
		# Using mysqldump
		"mysqldump")
			# Common mysql variables
			MYSQL_PATH=$(command -v mysql)
			MDUMP_PATH=$(command -v mysqldump)
			MYSQL_AUTH="-h ${DB_HOST} -u ${DB_USER} -p${DB_PASS} ${DB_NAME}"
			
			DB_DUMP=$TMP/zbx_backup_db_dump_${TIMESTAMP}.sql
			
			# Dumping DB structure
			if [[ "$MDUMP_PATH" ]] && [[ "$MYSQL_PATH" ]]
			then
				$MDUMP_PATH ${MYSQL_AUTH} --no-data > "$DB_DUMP"
			else
				echo "ERROR: 'mysqldump' or 'mysql' utility not found." | tee -a "$LOGFILE"
				return 1
			fi
			
			# If excluding detected, forming --ignore-table arguments
			if [[ "$EXCLUDE_TABLES" ]]
			then
				case "$EXCLUDE_TABLES" in
					"data")
						ZBX_DATA_TABLES=($($MYSQL_PATH ${MYSQL_AUTH} --batch --disable-column-names -e "SHOW TABLES;" | grep -P "$ZBX_TABLES_FILTER"))
						for TABLE in "${ZBX_DATA_TABLES[@]}"
						do
							IGNORE_ARGS+="--ignore-table=${DB_NAME}.${TABLE} "
						done
						;;
					"config")
						ZBX_CFG_TABLES=($($MYSQL_PATH ${MYSQL_AUTH} --batch --disable-column-names -e "SHOW TABLES;" | grep -vP "$ZBX_TABLES_FILTER"))
						for TABLE in "${ZBX_CFG_TABLES[@]}"
						do
							IGNORE_ARGS+="--ignore-table=${DB_NAME}.${TABLE} "
						done
						;;
					*)
						for TABLE in ${EXCLUDE_TABLES}
						do
							IGNORE_ARGS+="--ignore-table=${DB_NAME}.${TABLE} "
						done
						;;
				esac
				# Writing data with exclusions to dump
				$MDUMP_PATH ${MYSQL_AUTH} --single-transaction --no-create-info ${IGNORE_ARGS%?} >> "$DB_DUMP"
			else
				# Writing full data to dump
				$MDUMP_PATH ${MYSQL_AUTH} --single-transaction >> "$DB_DUMP"
			fi
			;;
		# Using xtrabackup
		"xtrabackup")
			# Exclusion hasn't implemented yet
			if [[ "$EXCLUDE_TABLES" ]]
			then
				echo "WARNING: Cannot use tables exclusion with xtrabackup yet. Full backup will be made." | tee -a "$LOGFILE"
			fi
			DB_DUMP=$TMP/zbx_backup_mysql_files_${TIMESTAMP}
			XTRABACKUP_PATH=$(command -v xtrabackup)
			if [[ "$XTRABACKUP_PATH" ]]
			then
				$XTRABACKUP_PATH --backup --user="$DB_USER" --password="$DB_PASS" \
					--no-timestamp --parallel=4 --target-dir="$DB_DUMP" 1>/dev/null 2>"$LOGFILE"
				$XTRABACKUP_PATH --prepare --user="$DB_USER" --password="$DB_PASS" \
					--no-timestamp --apply-log --target-dir="$DB_DUMP" 1>/dev/null 2>"$LOGFILE"
			else
				echo "ERROR: Cannot find 'xtrabackup' utility ($XTRABACKUP_PATH)." | tee -a "$LOGFILE"
				return 1
			fi
			;;
		*)
			echo "ERROR: You've setted incorrect backup utility. Use '--help'."
			return 1
			;;
	esac
}


# The function making rotation of old backup files
function RotateOldCopies() {
	# Getting old copies list and it's count
	OLD_COPIES=($(ls -1t "$DEST"/zbx_backup_*))
	COUNT=${#OLD_COPIES[@]}

	if [[ $COUNT -gt $ROTATION ]]
	then
		for OLD_COPY in "${OLD_COPIES[@]:$ROTATION}"
		do
			if [[ -f "$OLD_COPY" ]]
			then
				rm -f "$OLD_COPY"
			else
				echo "WARNING: $TIMESTAMP : Rotation. Something was wrong while deleting $OLD_COPY" >> "$LOGFILE"
			fi
		done
	else
		echo "INFO: $TIMESTAMP : Rotation. Less or equal $ROTATION old copies: $COUNT. Do nothing..." >> "$LOGFILE"
	fi
}

if [[ "$DEBUG" == "YES" ]]
then
	function join { local IFS="$1"; shift; echo "$*"; }

	printf "%-20s : %-25s\n" "Database host" "$DB_HOST"
	printf "%-20s : %-25s\n" "Database name" "$DB_NAME"
	printf "%-20s : %-25s\n" "Database user" "$DB_USER"
	printf "%-20s : %-25s\n" "Database password" "$DB_PASS"
	printf "%-20s : %-25s\n" "Use compression" "$USE_COMPRESSION"
	printf "%-20s : %-25s\n" "Compression utility" "$COMPRESS_WITH"
	printf "%-20s : %-25s\n" "Old copies count" "$ROTATION"
	printf "%-20s : %-25s\n" "Logfile location" "$LOGFILE"
	printf "%-20s : %-25s\n" "Temp directory" "$TMP"
	printf "%-20s : %-25s\n" "Final distination" "$DEST"
	printf "%-20s : %-25s\n" "Backup utility" "$B_UTIL"
	if ! [[ "$DB_ONLY" ]]; then printf "%-20s : %-30s\n" "Zabbix catalogs" "$(join ', ' "${ZBX_CATALOGS[@]}")"; fi
	if [[ "$EXCLUDE_TABLES" ]]; then printf "%-20s : %-30s\n" "Exclude tables" "$EXCLUDE_TABLES"; fi
	exit 0
fi

# Running backup function
if ! BackingUp
then
		echo "ERROR: $TIMESTAMP : Cannot create database backup" | tee -a "$LOGFILE"
		TmpClean
		exit 1
fi

# Compressing of packing to tar if resulted files exists
if [[ "$USE_COMPRESSION" ]]
then
	case $COMPRESS_WITH in
		"gzip")
			EXT="gz"
			;;
		"bzip2"|"lbzip2"|"pbzip2")
			EXT="bz2"
			;;
		"xz")
			EXT="xz"
			;;
	esac
	
	FULL_ARC="$DEST/zbx_backup_$TIMESTAMP.tar.$EXT"
	if [[ "$DB_ONLY" ]]
	then
		tar cf "$FULL_ARC" -I "$COMPRESS_WITH" "$DB_DUMP" 2>/dev/null
	elif [[ -f "$ZBX_FILES_TAR" ]]
	then
		tar cf "$FULL_ARC" -I "$COMPRESS_WITH" "$ZBX_FILES_TAR" "$DB_DUMP" 2>/dev/null
	fi
else
	FULL_ARC="$DEST/zbx_backup_$TIMESTAMP.tar"
	if [[ "$DB_ONLY" ]]
	then
		tar cf "$FULL_ARC" "$DB_DUMP" 2>/dev/null
	elif [[ -f "$ZBX_FILES_TAR" ]]
	then
		tar cf "$FULL_ARC" "$ZBX_FILES_TAR" "$DB_DUMP" 2>/dev/null
	fi
fi

# Cleaning temp 
TmpClean

# Running rotation if needed
if ! [[ "$ROTATION" =~ ^[Nn][Oo]$ ]]; then RotateOldCopies; fi

# Cheking and logging results
if [[ -f "$FULL_ARC" ]]
then
	FULL_SIZE=$(du -sh "$FULL_ARC" | cut -f1)
	echo "INFO: $TIMESTAMP : Backup job success. Result file sise is $FULL_SIZE." >> "$LOGFILE"
	exit 0
else
	echo "ERROR: $TIMESTAMP : Backup job failed, archive wasn't created." >> "$LOGFILE"
	exit 1
fi
exit 0
