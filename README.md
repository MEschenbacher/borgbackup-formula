# What this formula does

This formula will install the borgbackup package (assuming it is already
available on your machine's sources).
The clients will periodically (via cron) run a `borgbackup.sh` which pushes
backups to a master. Borg supports backups on local filesystems and remote hosts
via ssh. This formula requires ssh keys to be used when connecting to a remote
host via ssh.

Both states `borg.backup` and `borg.check` are supposed to be activated. With the default
configuration borg will backup every night, except on sundays where a backup plus a borg check
will be done.

# Requirements

 - cron
 - cronic (will be installed automatically)

# Installation

See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html).

# Configuration

Carefully read through the default list of included and excluded backup dirs under
`borg/defaults.yaml`.

Configuration is done via pillar. See `example.pillar` for examples.

# States

  - `borg.backup` Installs borgbackup, sets up `borgbackup.sh` and
    `borgcheck.sh`. **Important**: Run `/root/borgbackup.sh` once manually
    because ssh needs to verify the host and asks you to accept the hostkey.
  - `borg.master` Installs borgbackup, sets up repositories and sets up
    `authorized_keys`
