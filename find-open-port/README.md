# find-open-port.sh

Find the first open port in the range from 1024 to 8192 or any range you
specify. Useful if you want to bind your (node.js) application to some port on
[Uberspace](https://uberspace.de).

## Usage

```shell
$ ./find-open-port.sh
```

Or find an open port in the range from 1024 to 2048:

```shell
$ ./find-open-port.sh 1024 2048
```

## License

`find-open-port.sh` is licensed under the MIT license. See
`find-open-port.sh` itself for the full license.
