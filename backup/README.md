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

## Command line arguments

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
