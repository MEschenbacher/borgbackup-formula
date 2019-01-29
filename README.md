# What this formula does

This formula will install the borgbackup package (assuming it is already
available on your machine's sources).
The clients will periodically (via cron) run a `borgbackup.sh` which pushes
backups to a master. Borg supports backups on local filesystems and remote hosts
via ssh. This formula requires ssh keys to be used when connecting to a remote
host via ssh.

# Requirements

 - cron
 - cronic (will be installed automatically)

# Installation

See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html).

# Configuration

Configuration is done via pillar. See `example.pillar` for examples.

# States

  - `borg.backup` Installs borgbackup, sets up `borgbackup.sh` and
    `borgcheck.sh`. **Important**: Run `/root/borgbackup.sh` once manually
    because ssh needs to verify the host and asks you to accept the hostkey.
  - `borg.master` Installs borgbackup, sets up repositories and sets up
    `authorized_keys`
