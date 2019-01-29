create user for borgbackup:
  user.present:
    - name: {{salt.pillar.get('borg:master:user')}} 
    - system: True

create directory for borgbackup:
  file.directory:
    - name: {{salt.pillar.get('borg:master_archive_base')}} 
    - user: {{salt.pillar.get('borg:master:user')}} 
    - makedirs: True

{% for entry in salt.pillar.get('borg:master:repos', []) %}
{% for pubkeyentry in entry.get('pubkeys', []) %}
borg backup key for repo {{entry.get('reponame')}} and user {{pubkeyentry.get('comment', pubkeyentry.get('pubkey'))}}:
  ssh_auth.present:
    - name: {{pubkeyentry.get('pubkey')}}
    - user: {{salt.pillar.get('borg:master:user')}}
    - enc: {{pubkeyentry.get('enc', 'ssh-ed25519')}}
    - comment: {{pubkeyentry.get('comment', '')}}
    - options:
      - command="cd {{salt.pillar.get('borg:master_archive_base')}}{{entry.get('reponame')}}; borg serve --append-only --restrict-to-path {{salt.pillar.get('borg:master_archive_base')}}{{entry.get('reponame')}}"
      - no-port-forwarding
      - no-X11-forwarding
      - no-pty
      - no-agent-forwarding
      - no-user-rc
{% endfor %}

create borg repo {{entry.get('reponame')}}:
  cmd.run:
{% if entry.get('passphrase', 'none') == 'none' %}
    - name: borg init -e none {{salt.pillar.get('borg:master_archive_base')}}{{entry.get('reponame')}}
{% else %}
    - name: BORG_PASSPHRASE={{entry.get('passphrase')}} borg init -e repokey {{salt.pillar.get('borg:master_archive_base')}}{{entry.get('reponame')}}
{% endif %}
    - runas: {{salt.pillar.get('borg:master:user')}}
    - creates:
      - {{salt.pillar.get('borg:master_archive_base')}}{{entry.get('reponame')}}
{% endfor %}
