#
# This function provides simple autocompletion to zbx-backup script
# Place it to /etc/bash_completion.d/ and run next command:
# . /etc/bash_completion.d/zbx-backup.bash
# Option set is corresponds to v0.5.2 and higher.
#

zbx_backup_autocomplete() {
	# Declare local variables
	local CUR PREV MAIN_OPTS COMPRESS_UTILS
	
	COMPREPLY=()
	CUR="${COMP_WORDS[COMP_CWORD]}"
	PREV="${COMP_WORDS[COMP_CWORD-1]}"
	MAIN_OPTS="--help --version --save-to --backup-with --temp-folder --compress-with --rotation --use-xtrabackup --use-mysqldump --db-only --db-user --db-password --db-name --debug"
	COMPRESS_UTILS="gzip bzip2 lbzip2 pbzip2 xz"
	BACKUP_UTILS="mysqldump xtrabackup"
	if [[ ${CUR} == -* ]]
	then
		COMPREPLY=( $(compgen -W "${MAIN_OPTS}" -- ${CUR}) )
		return 0
	fi
	# Compress with
	if [[ ${PREV} == '--compress-with' ]]
	then
		case "${CUR}" in
			 [a-zA-Z])
				COMPREPLY=( $(compgen -W "${COMPRESS_UTILS}" -- ${CUR}) )
				return 0
				;;
			'')
				COMPREPLY=( $(compgen -W "${COMPRESS_UTILS}") )
				return 0
				;;
		esac
	fi
	# Backup with
	if [[ ${PREV} == '--backup-with' ]]
	then
		case "${CUR}" in
			 [a-zA-Z])
				COMPREPLY=( $(compgen -W "${BACKUP_UTILS}" -- ${CUR}) )
				return 0
				;;
			'')
				COMPREPLY=( $(compgen -W "${BACKUP_UTILS}") )
				return 0
				;;
		esac
	fi
}

complete -F zbx_backup_autocomplete zbx-backup
