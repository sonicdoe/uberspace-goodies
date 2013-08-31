# uberspace-backup.sh

Backup `/home/username`, `/var/www/virtual/username` and MySQL databases from
your [Uberspace](https://uberspace.de).

## Usage

Simply running

```shell
$ ./uberspace-backup.sh
```

will read all Uberspace accounts from `~/.ssh/config` and perform a backup to
`~/uberspace-backups`.

Here’s a more advanced example (using all possible [command line arguments](#arguments)):

```shell
$ ./uberspace-backup.sh -a -h uberspace-johndoe -h uberspace-galaxy -b ~/backups -s /etc/ssh/ssh_config
```

---

**Note**: Unless you run `uberspace-backup.sh` in [archive mode](#archive-argument)
only a mirror of your Uberspace will be created. In plain English this means it
creates an “Aaa, Uberspace lost all my files!” kinda backup but not an “I
accidentally deleted a file three months ago” kinda backup.

## Command line arguments [arguments]

### -a [archive-argument]

Create a local .tar.bz2-archive instead of syncing all files incrementally (placed into `~/uberspace-backups/archives`).

### -b *backup-dir*

Specify the backup destination, defaults to `~/uberspace-backups`.

### -h *host*

Specify host(s) to backup. The `host` has to exist in your ssh config. You can
pass this argument multiple times to specify multiple hosts.

### -s *ssh-config-file*

Specify the location of your ssh configuration file, defaults to
`~/.ssh/config`.

## Backup directory structure

The backup directory is structured similar to [Uberspace’s own backup system](http://uberspace.de/dokuwiki/system:backup).

- `/home/username` → `home/username`
- `/var/www/virtual/username` → `var/www/virtual/username`
- MySQL databases → `mysqlbackup/username/all-databases.sql.xz`

## Credits

Inspired by [pheraph’s backup-uberspace.sh](https://gist.github.com/pheraph/6376979#file-backup-uberspace-sh)
and [DirkR’s uberspaces.pl](https://gist.github.com/DirkR/1613079).

## License

`uberspace-backup.sh` is licensed under the MIT license. See
`uberspace-backup.sh` itself for the full license.
