#!/usr/bin/env bash

export BORG_REPO={{salt.pillar.get('borg:archive_base')}}{{salt.pillar.get('borg:reponame', '$HOSTNAME')}}
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
export BORG_PASSPHRASE={{salt.pillar.get('borg:passphrase', '')}}

borg create '::{{salt.pillar.get('borg:archive_name', '{hostname}-{now}')' \
	/ \
	--exclude /bin \
	--exclude /boot \
	--exclude /dev \
	--exclude /lib \
	--exclude /lib64 \
	--exclude /mnt \
	--exclude /proc \
	--exclude /run \
	--exclude /sbin \
	--exclude /sys \
	--exclude /tmp \
	--exclude /usr/lib \
	--exclude /usr/share \
	--exclude /usr/bin \
	--exclude /usr/sbin \
	--exclude /usr/include \
{%- for path in salt.pillar.get('borg:exclude', []) %}
	--exclude {{path}} \
{%- endfor %}
	--exclude '/**/.ccache' \
	--exclude /var/cache \
	--exclude /var/tmp || exit $?

# borg prune -v $REPO --prefix '{hostname}-' \
	# --keep-daily=7 --keep-weekly=4 --keep-monthly=6

exit $?
