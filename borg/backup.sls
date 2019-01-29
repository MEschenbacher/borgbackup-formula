borgbackup package:
  pkg.installed:
    - name: borgbackup

cronic package:
  pkg.installed:
    - name: cronic

/root/borgbackup.sh:
  file.managed:
    - source: salt://borg/files/borgbackup.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700 # script includes a password

/root/borgcheck.sh:
  file.managed:
    - source: salt://borg/files/borgcheck.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700 # script includes a password

default shell for cron /bin/bash:
  cron.env_present:
    - user: root
    - name: SHELL
    - value: /bin/bash

cronjob for borg:
  cron.present:
    - identifier: borgbackup
    - name: sleep ${RANDOM:0:2}m ; cronic /root/borgbackup.sh
    - user: root
    - hour: 4
    - minute: 5

cronjob for borgcheck:
  cron.present:
    - identifier: borgcheck
    - name: sleep ${RANDOM:0:2}m ; cronic /root/borgcheck.sh
    - user: root
    - hour: 5
    - minute: 5
    - dayweek: 0 # sunday
