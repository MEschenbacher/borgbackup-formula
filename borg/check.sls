{% from "borg/map.jinja" import borg with context %}

include:
  - borg.init

/root/borgcheck.sh:
  file.managed:
    - source: salt://borg/files/borgcheck.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700 # script includes a password

{% if borg.cron_check_enabled %}
borg-check-cron:
  cron.present:
    - identifier: borgcheck
    - name: {{ borg.cron_check_command }}
    - user: root
    - minute: {{ borg.cron_check_minute }}
    - hour: {{ borg.cron_check_hour }}
    - dayweek: {{ borg.cron_check_dayweek }}
    - comment: Do a borg check
{% else %}
disable-borg-backup-cron:
  cron.absent:
    - identifier: borgcheck
{% endif %}
