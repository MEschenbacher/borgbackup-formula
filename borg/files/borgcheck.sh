{%- from "borg/map.jinja" import borg with context -%}
#!/bin/bash

# This file is managed by Salt, do not edit by hand!

export BORG_REPO={{borg.archive_base}}{{borg.get('reponame', '$HOSTNAME')}}
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
export BORG_PASSPHRASE={{borg.get('passphrase', '')}}

borg check :: \
{%- if borg.check.get('last') %}
	--last {{borg.check.last}} \
{%- endif %}
	|| exit $?

exit $?
