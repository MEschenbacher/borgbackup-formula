#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

shopt -s nullglob

if [ "$(uname)" != "Linux" ]; then
	exit 0
fi

remove_backup () {
	rm -rf /var/backups/*.luks
}

for i in "$@"; do
	if [ "$i" = "--remove" ]; then
		remove_backup
		exit 0
	fi
done

blkid >& /dev/null || ( echo blkid not found. check PATH >&2; exit 1 )

if [ $(blkid | grep crypto_LUKS | cut -d: -f 1 | sort | uniq | wc -l) -ne $(blkid | grep crypto_LUKS | cut -d: -f 1 | wc -l) ]; then
	echo luks device names are not unique >&2
	exit 1
fi

for i in $(blkid | grep crypto_LUKS | cut -d: -f 1); do
	partition=$(basename "$i")
	cryptsetup luksHeaderBackup --header-backup-file /var/backups/"$partition".luks "$i"
done
