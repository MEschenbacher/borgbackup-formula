#!/usr/bin/env bash

export BORG_REPO={{salt.pillar.get('borg:archive_base')}}{{salt.pillar.get('borg:reponame', '$HOSTNAME')}}
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
export BORG_PASSPHRASE={{salt['pillar.get']('borg:passphrase', '')}}

borg check :: --last 7 || exit $?

exit $?
