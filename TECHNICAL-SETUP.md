# Requirements

## Install Go

This installation method removes existing Go installations, installs Go in `/usr/local/go/bin/go`, and sets
the environment variables.

1. Go to <https://golang.org/dl>.
1. Download the binary release that is suitable for your system.
1. Follow the installation instructions.

**Note:** We recommend not using brew to install Go.

## Install Dev Tools

### install pre-commit

#### Homebrew

```shell
brew install pre-commit
```

#### Ubuntu / Debian based linux distributions

```shell
sudo apt-get install pre-commit
```

### golangci-lint

`golangci-lint` is a linter runner used in the `make lint` command provided to developers. 
To install it into `$GOPATH/bin` run:

```shell
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.41.1
```
