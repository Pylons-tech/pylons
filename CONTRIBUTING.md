# Contributing

Thank you for considering making contributions to Pylons and related repositories!

Contributing to this repo can mean many things such as participated in
discussion or proposing code changes. To ensure a smooth workflow for all
contributors, the general procedure for contributing has been established:

1. Either [open](https://github.com/Pylons-tech/pylons/issues/new/choose) or
   [find](https://github.com/Pylons-tech/pylons/issues) an issue you'd like to help with
2. Participate in thoughtful discussion on that issue
3. If you would like to contribute:
    1. If the issue is a proposal, ensure that the proposal has been accepted
    2. Ensure that nobody else has already begun working on this issue, if they have
       make sure to contact them to collaborate
    3. If nobody has been assigned the issue, and you would like to work on it
       make a comment on the issue to inform the community of your intentions
       to begin work
    4. Follow standard GitHub best practices: fork the repo, branch from the
       HEAD of `develop`, make some commits, and submit a PR to `develop`
        - For core developers working within the Pylons repo, to ensure a clear
          ownership of branches, branches must be named with the convention
          `{moniker}/{issue#}-branch-name`
    5. Be sure to submit the PR in `Draft` mode submit your PR early, even if
       it's incomplete as this indicates to the community you're working on
       something and allows them to provide comments early in the development process
    6. When the code is complete it can be marked `Ready for Review`
    7. Be sure to include a relevant change log entry in the `Unreleased` section
       of `CHANGELOG.md` (see file for log format)

Note that for very small or blatantly obvious problems (such as typos) it is
not required to an open issue to submit a PR, but be aware that for more complex
problems or features, if a PR is opened before an adequate design discussion has
taken place in a GitHub issue, that PR runs a high likelihood of being rejected.

Take a peek at the Tendermint [coding repo](https://github.com/tendermint/coding) for
overall information on repository workflow and standards. Setup for development
tools like linters is detailed on the [technical setup](TECHNICAL-SETUP.md) guide.

Other notes:
* Looking for a good place to start contributing? How about checking out some
  [good first issues](https://github.com/Pylons-tech/pylons/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22).

* Please make sure to run `make format` before every commit - the easiest way
  to do this is have your editor run it for you upon saving a file. Additionally,
  to ensure that your code is lint-compliant run `make lint`.

## Forking

Please note that Go requires code to live under absolute paths, which complicates forking.
While my fork lives at `https://github.com/aljo242/pylons`,
the code should never exist at  `$GOPATH/src/github.com/aljo242/pylons`.
Instead, we use `git remote` to add the fork as a new remote for the original repo,
`$GOPATH/src/github.com/Pylons-tech/pylons`, and do all the work there.

For instance, to create a fork and work on a branch of it, I would:

- Create the fork on GitHub, using the fork button.
- Go to the original repo checked out locally (i.e. `$GOPATH/src/github.com/Pylons-tech/pylons`)
- `git remote rename origin upstream`
- `git remote add origin git@github.com:aljo242/pylons.git`

Now `origin` refers to my fork and `upstream` refers to the Pylons version.
So I can `git push -u origin main` to update my fork, and make pull requests to Pylons from there.
Of course, replace `aljo242` with your git handle.

To pull in updates from the origin repo, run

- `git fetch upstream`
- `git rebase upstream/main` (or whatever branch you want)

Please don't make Pull Requests to `main`.

## Dependencies

We use [Go Modules](https://github.com/golang/go/wiki/Modules) to manage
dependency versions.

The main branch of every Pylons repository should just build with `go get`,
which means they should be kept up-to-date with their dependencies so we can
get away with telling people they can just `go get` our software.

When dependencies in Pylons' `go.mod` are changed, it is generally accepted practice
to delete `go.sum` and then run `go mod tidy`.

Since some dependencies are not under our control, a third party may break our
build, in which case we can fall back on `go mod tidy -v`.

<!-- 
Add more sections on Branching Model and Releases
-->