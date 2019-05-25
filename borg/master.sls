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
      - command="cd {{salt.pillar.get('borg:master:archive_base')}}/{{entry.get('reponame')}}; borg serve --append-only --restrict-to-path {{salt.pillar.get('borg:master:archive_base')}}/{{entry.get('reponame')}}"
      - restrict
{% endfor %}

{% set create_command = '' %}
{% if entry.get('passphrase') %}
{% set create_command = create_command ~ 'BORG_PASSPHRASE=' ~ entry.passphrase ~ ' ' %}
{% endif %}
{% set create_command = create_command ~ 'borg init ' %}

create borg repo {{entry.get('reponame')}}:
  cmd.run:
    - name: >
        {{ create_command }}
        {%- for o in entry.get('init_options', []) %}
        {{o}}
        {%- endfor %}
        {{salt.pillar.get('borg:master:archive_base')}}/{{entry.get('reponame')}}
    - runas: {{salt.pillar.get('borg:master:user')}}
    - creates:
      - {{salt.pillar.get('borg:master:archive_base')}}/{{entry.get('reponame')}}
{% endfor %}
