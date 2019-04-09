{% from "borg/map.jinja" import borg with context %}

include:
  - borg.init

/root/borgbackup.sh:
  file.managed:
    - source: salt://borg/files/borgbackup.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700 # script includes a password

{% if borg.cron_enabled %}
borg-backup-cron:
  cron.present:
    - identifier: borgbackup
    - name: {{ borg.cron_command }}
    - user: root
    - minute: {{ borg.cron_minute }}
    - hour: {{ borg.cron_hour }}
    - dayweek: {{ borg.cron_dayweek }}
    - comment: Create a borg backup
{% else %}
disable-borg-backup-cron:
  cron.absent:
    - identifier: borgbackup
{% endif %}
