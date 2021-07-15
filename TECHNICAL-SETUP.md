# Requirements

The following list contains all software dependencies necessary to set up Pylons development environment.

## Development tools

### Go programing language    
Install [Golang >= 1.16.2](https://golang.org/doc/install), the programming language in which Pylons is implemented.

### Go Linter

Install [Golangci Lint](https://golangci-lint.run/usage/install/#local-installation), used for code linting.

### Starport

Install [Starport](https://docs.starport.network/intro/install.html), the Cosmos SDK command-line tool for scaffolding and maintaining modules, types, messages, and other code in the Pylons blockchain.

### Make

Install make that is used to execute building actions at the development stage. The installation procedure varies, depending on your operating system, so
a list of options is provided as follows:

#### Debian and Ubuntu-based distributions

```bash
$ sudo apt install build-essential
```

##### Fedora and RHL-based distributions

```bash
$ sudo apt install build-essential
```

#### Arch Linux
```bash
$ sudo pacman -Sy base-devel
```      

##### Windows
Use [chocolatey](https://chocolatey.org/)
```bash
choco install make
```

##### MacOS

Use [homebrew](https://formulae.brew.sh/formula/make)

## Infrastructure and maintenance tools 

Install [Precommit](https://pre-commit.com/), a tool used to verify the code before commiting it. It depends on git.

Install [Docker](https://docs.docker.com/get-docker/), the very popular container tool.
