# Working with the Source Code

After setting up a [development environment](Setting-up-a-development-environment) you can start tinkering with the code.

## Building the addon

 From the source code's root directory run:

```bash
make
# or
make xpi
```

The XPI file will be created at `dist/requestpolicy.xpi`.

## Installing the XPI

You can simply drag-and-drop the file into your web browser (e.g. Firefox).

## Running Firefox and RP with Mozrunner

`mozrunner` is a python package that helps you run Mozilla binaries (firefox, thunderbird, seamonkey, …) in a predefined environment. Every time you run `mozrunner`, it will create a new temporary profile – it will be deleted afterwards.

Usage examples:

```bash
# Run Firefox Nightly
# -- binary path: .mozilla/software/firefox/nightly/firefox
make run
```

This will also automatically create or update the XPI file, if necessary. In this case the „unit testing“ XPI will be created – command: `make unit-testing-xpi`.


## Running unit tests

Setting up an environment for unit testing is optional. You probably won't need it if you do just a few changes to the code.

### What is unit testing?

Unit testing ([wikipedia](https://en.wikipedia.org/wiki/Unit_test)) aims at ensuring that functionality that has been implemented is really working, also across different versions and also in case bigger changes to the source code are done.

### Unit tests for RequestPolicy

There are two types of unit tests: xpcshell tests and Marionette tests. There are also still some MozMill tests, but they will be converted to Marionette tests, see issue [#641](https://github.com/RequestPolicyContinued/requestpolicy/issues/641).

Marionette (and formerly MozMill) is used to test UI functionality, whereas the xpcshell is used for tests which only need access to XPCOM.

So far there are only few unit tests, so contributions are very welcome. In future any new feature should get a unit test.

#### xpshell tests

```bash
./tests/run-xpcshell-tests.sh
```

#### Marionette tests

```bash
make marionette
```

Note that while the tests are running you shouldn't use keyboard/mouse at all, otherwise tests might fail erroneously.

#### MozMill tests (obsolete)

```bash
make mozmill
```
