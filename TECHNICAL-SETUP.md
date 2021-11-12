# Technical Setup 

To ensure you have a successful experience working with Pylons, your local system must meet these technical requirements.

## Install Go

This installation method removes existing Go installations, installs Go in `/usr/local/go/bin/go`, and sets
the environment variables.

1. Go to <https://golang.org/dl>.
1. Download the binary release that is suitable for your system.
1. Follow the installation instructions.

**Note:** We recommend not using brew to install Go.

## Install Starport

To install the latest version of the `starport` binary use the following command.

```shell
curl https://get.starport.network/starport! | bash
```

## Install Dev Tools

### pre-commit

`pre-commit` runs hooks before any commit to the git repository.  These hooks verify that any commit passes basic formatting and linting checks.

#### Homebrew

```shell
brew install pre-commit
```

#### Ubuntu / Debian based linux distributions

```shell
sudo apt install pre-commit
```

#### Setting up precommit in the project

After installing the binary, run the following command in the base directory of the `pylons` repository:

```shell
pre-commit install
```

Now, any time `git commit *` is run, the `pre-commit` hooks  run before the commit can be finalized.

### golangci-lint

The `golangci-lint` linter runner is used in the `make lint` command that is provided to developers.

To install `golangci-lint` into `$GOPATH/bin`, run:

```shell
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.41.1
```