{% from "borg/map.jinja" import borg with context %}

borgbackup-pkg:
  pkg.installed:
    - name: {{ borg.pkg }}

cronic-pkg:
  pkg.installed:
    - name: {{ borg.cronic_pkg }}

default shell for cron /bin/bash:
  cron.env_present:
    - user: root
    - name: SHELL
    - value: /bin/bash
