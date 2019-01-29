#!/usr/bin/env bash

readonly REPO=ssh://borg@borg.kajt.de:42/srv/borg-repos/{{salt['pillar.get']('borg:reponame', '$HOSTNAME')}}

export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
export BORG_PASSPHRASE={{salt['pillar.get']('borg:passphrase', '')}}

borg check $REPO --last 7 || exit $?

exit $?
