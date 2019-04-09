{% from "borg/map.jinja" import borg with context %}

borgbackup-pkg:
  pkg.installed:
    - name: {{ borg.pkg }}

cronic-pkg:
  pkg.installed:
    - name: {{ borg.cronic_pkg }}
