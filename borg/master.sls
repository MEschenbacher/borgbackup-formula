include:
  - borg.init

create user for borgbackup:
  user.present:
    - name: {{salt.pillar.get('borg:master:user')}}
    - system: True

create directory for borgbackup:
  file.directory:
    - name: {{salt.pillar.get('borg:master:archive_base')}}
    - user: {{salt.pillar.get('borg:master:user')}}
    - makedirs: True

{% for entry in salt.pillar.get('borg:master:repos', []) %}
{% set repopath = salt.pillar.get('borg:master:archive_base') ~ '/' ~ entry.get('reponame') %}
{% for pubkeyentry in entry.get('pubkeys', []) %}
{% if pubkeyentry.get('delete', False) %}
remove borg backup key {{pubkeyentry.get('pubkey')}} for repo {{entry.get('reponame')}} and user {{salt.pillar.get('borg:master:user')}}:
  ssh_auth.absent:
{% else %}
borg backup key {{pubkeyentry.get('pubkey')}} for repo {{entry.get('reponame')}} and user {{salt.pillar.get('borg:master:user')}}:
  ssh_auth.present:
{% endif %}
    - name: {{pubkeyentry.get('pubkey')}}
    - user: {{salt.pillar.get('borg:master:user')}}
    - enc: {{pubkeyentry.get('enc', 'ssh-ed25519')}}
    {% if pubkeyentry.get('comment') %}
    - comment: {{pubkeyentry.get('comment')}}
    {% endif %}
    - options:
      - command="cd {{repopath}}; borg serve --append-only --restrict-to-path {{repopath}}"
      - restrict
{% endfor %}

{% set create_command = '' %}
{% if entry.get('passphrase') %}
  {% set create_command = create_command ~ 'BORG_PASSPHRASE=' ~ entry.passphrase ~ ' borg init' %}
{% else %}
  {% set create_command = create_command ~ 'borg init --encryption=none' %}
{% endif %}

create borg repo {{entry.get('reponame')}}:
  cmd.run:
    - name: >
        {{ create_command }}
        {%- for o in entry.get('init_options', []) %}
        {{o}}
        {%- endfor %}
        {{repopath}}
    - runas: {{salt.pillar.get('borg:master:user')}}
    - creates:
      - {{repopath}}
{% endfor %}
