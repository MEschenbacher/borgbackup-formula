{% from "borg/map.jinja" import borg with context %}

include:
  - borg.init

borgbackup.sh script:
  file.managed:
    - name: /root/borgbackup.sh
    - source: salt://borg/files/borgbackup.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700 # script includes a password

borgwrapper.sh script:
  file.managed:
    - name: /root/borgwrapper.sh
    - source: salt://borg/files/borgwrapper.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700 # script includes a password

{% for entry in borg.cron %}
{% if entry.enabled %}
cron {{entry.identifier}}:
  cron.present:
    - identifier: {{entry.identifier}}
    - name: >
        {{entry.command}}
    - user: root
    - minute: {{entry.minute}}
    - hour: {{entry.hour}}
    - dayweek: {{entry.dayweek}}
    - comment: Create a borg backup
{% else %}
disable cron {{entry.identifier}}:
  cron.absent:
    - identifier: {{entry.identifier}}
{% endif %}
{% endfor %}
