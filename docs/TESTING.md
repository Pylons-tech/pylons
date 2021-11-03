# Testing Pylons

The core tests for `pylons` are exposed through the `Makefile`.  Tests and the commands to run them are detailed below:

## Tests

Unit and integration tests: 

```shell
make test
```

To get a quick view of failing tests run:

```shell
make test | grep FAIL
```

To test for race conditions:

```shell
make test-race
```

To generate a coverage report (in `cover.html`) run:

```shell
make test-cover
```

## Simulation Tests

To test using a simulation for non-determinism:

```shell
make test-sim-nondeterminism
```

## Benchmarking

```shell
make bench
```

