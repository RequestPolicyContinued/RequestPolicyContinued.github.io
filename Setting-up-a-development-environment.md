# Setting up a development enironment
<!-- HTMLTITLE Setting up a development environment - RequestPolicy Continued -->

## Getting the Source Code

If you'd like to download the RequestPolicy source code from our version
control system, you can do so with:

```bash
git clone https://github.com/RequestPolicyContinued/requestpolicy.git
```

The above command will create a directory called `requestpolicy`. Under that
is a `src` directory where the source code lives.

By the way, any XPI file (the extension file you install in your browser)
contains all of the source code as well. XPI files are just zip
archives which you can extract like any other. However, in version control
there's a `chrome.manifest` file for local development that you'll probably
want to use even if you're working from an extracted XPI. 

## Building the Extension XPI

We use [GNU Make](https://www.gnu.org/software/make/). To create the XPI file, simply run 

```bash
make
```

from the repo's root directory. After that the xpi will be located at `dist/requestpolicy.xpi`.

## Run Firefox & RP with `mozrunner`

`mozrunner` is a python package that helps you run Mozilla binaries (firefox, thunderbird, seamonkey, …) in a predefined environment. Every time you run `mozrunner`, it will create a new temporary profile – it will be deleted afterwards.

### preparation steps
#### install `mozrunner`

You can install [`mozrunner`](http://pypi.python.org/pypi/mozrunner) via `python-pip`. On a debian system, run:

```
sudo apt-get install python-pip
sudo pip install mozmill
```
#### Firefox Nightly

Download the file you need from http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-central/

Install/extract the files into `${rp_root_dir}/.mozilla/software/firefox/nightly/`. The binary file named `firefox` should be directly in that directory.

**Hint:** If you want, you could also install Fx Nightly elsewhere and create a symlink from `${rp_root_dir}/.mozilla/software/firefox/nightly/` to that directory.

### run `mozrunner`

First you have to prepare your environment, see below. When you're done, run
```
make run
```
Firefox Nightly will start up with a completely fresh profile and with RP installed. For more information, take a look at the `Makefile`'s `run` target.


## Developing Without Rebuilding the XPI

It's annoying to have to rebuild and reinstall the extension constantly during
development. To avoid that, you can create a "proxy" extension by creating a
file in your Firefox profile's extensions directory which tells Firefox that
it should look for the unpackaged extension files in a directory of your
choice.

### Quick instructions

1. Create a [new firefox profile](http://kb.mozillazine.org/Profile_Manager#Creating_a_new_profile), e.g. called `rp-dev`.
2. Start firefox with the new profile (e.g. `firefox -no-remote -P rp-dev`)  and close it again.
3. Figure out the [profile directory](http://kb.mozillazine.org/Profile_folder_-_Firefox#Navigating_to_the_profile_folder), go there and run this command: `echo "/path/to/requestpolicy/src" > requestpolicy@requestpolicy.com` (or do it by hand).

### Detailed instructions

To install a proxy extension, first create a new Firefox profile through the
Firefox profile manager. To open the profile manager:

```bash
firefox -no-remote -profilemanager
```

Start Firefox using that profile, either selecting it in the profile manager
or using the command:

```bash
firefox -no-remote -P PROFILENAME
```

Now close this Firefox instance.

After you've created the new profile, figure out the
[profile directory](http://kb.mozillazine.org/Profile_folder_-_Firefox#Navigating_to_the_profile_folder).
On Linux, it will often be `~/.mozilla/firefox/*/`.
I'll call this `PROFILE_DIRECTORY` from here on out.

Next, use the following commands to create the proxy extension file for
RequestPolicy in your new profile.

```bash
# Change directory to your new profile's directory.
cd PROFILE_DIRECTORY

# Create the 'extensions' directory and change to that directory.
mkdir -p extensions
cd extensions

# Create a file called 'requestpolicy@requestpolicy.com' with a single
# line in the file which is the path to the 'src' directory. 
echo "/path/to/requestpolicy/src" > requestpolicy@requestpolicy.com
```

Now start Firefox again using that profile. Firefox should now consider the
extension installed. To verify this, go to Tools > Addons > Extensions. You
should see RequestPolicy listed among the extensions.

### Troubleshooting

If RequestPolicy is not installed at this point, you may need to repeat the
above steps to create the proxy extension file before trying again. This is
because if Firefox sees a problem with your proxy extension file (e.g. it's
named incorrectly or the path to the `src` directory in the file is
incorrect), Firefox may delete the file.

Note that you shouldn't try to install the extension xpi in a profile where
you've already created the proxy extension. To use an xpi that you've built,
use a new profile.


## enable logging

Logging is independant from the previous steps and can be done for any firefox profile. RequestPolicy's logging gives a lot of information about what is going on, so at least for delevoping it's recommended enable it.

By the way, besides RequestPolicy's own logging there's the [Browser Console](https://developer.mozilla.org/en-US/docs/Tools/Browser_Console). Sometimes its output is very helpful for debugging. There's an issue about moving RequestPolicy's logging to the Browser Console, see [#563](https://github.com/RequestPolicyContinued/requestpolicy/issues/563).

### summary

On `about:config`, set `extensions.requestpolicy.log` to `true`. Logging is done to `stderr`.

### more in detail

To enable logging open the URL `about:config` in firefox and search for the keys containing `requestpolicy`. Locate the one called `extensions.requestpolicy.log`. Double-click this row to change the value to `true`. Logging should now be enabled immediately, but to see the output, you need to start firefox from the command line. The logging will be done to `stderr`, not to Firefox's error console.

If you want to capture the logged information to a file, you can redirect `stderr` to a file when you start Firefox. For example, the following command will start Firefox in the background and will redirect both `stdout` and `stderr` to a file named `rp.log`:

```bash
firefox -no-remote -P PROFILENAME >rp.log 2>&1 &
```


## Unit tests

Setting up an environment for unit testing is an optional, which is probably not needed if you do just a few changes to the code.

### What is unit testing?
Unit testing ([wikipedia](https://en.wikipedia.org/wiki/Unit_test)) aims at ensuring that functionality that has been implemented is really working, also across different versions and also in case bigger changes to the source code are done.

## Unit tests for RequestPolicy

There are two types of unit tests: MozMill tests and xpcshell tests. You can find setup instructions below. MozMill is used to test UI functionality, whereas the xpcshell is used for tests which only need access to XPCOM.

So far there are only few unit tests, so contributions are very welcome. To ensure quality of RP, every new feature should always get a unit test.

If you have any suggestion, please post it issue [#51](https://github.com/RequestPolicyContinued/requestpolicy/issues/51) or in a new one. If you have any questions, don't hesitate to ask! :)

### MozMill

MozMill tests are currently documented and developed in [issue #487](https://github.com/RequestPolicyContinued/requestpolicy/issues/487).

#### Install and configure

If you want to run the MozMill tests, first install MozMill and get the `mozmill-tests` repository. Instructions you can find [here](https://developer.mozilla.org/en-US/docs/Mozilla/QA/Mozmill_tests#Installing_Mozmill). Put the `mozmill-tests` directory into `${rp_root_dir}/.mozilla/`.

In the `mozmill-tests` folder, create a symbolic link `firefox/tests/addons/requestpolicy@requestpolicy.com/` which links to the `test/mozmill` directory of the RP source code. After that, you have to add a new line to your `/etc/hosts` file:

```
127.0.0.1       maindomain.test www.maindomain.test sub-1.maindomain.test sub-2.maindomain.test otherdomain.test www.otherdomain.test sub-1.otherdomain.test sub-2.otherdomain.test thirddomain.test www.thirddomain.test sub-1.thirddomain.test sub-2.thirddomain.test
```

Not all of those domains are used at the moment, but they will, so add them all. By the way, `.test` is a [reserved TLD](https://en.wikipedia.org/wiki/.test).

To be able to access the test html files, you need a web server on port 80. One very simple method is to use python – execute `sudo python -m SimpleHTTPServer 80` in RP's `test/content/` directory, but note that some tests require a web server with PHP support such as the Apache HTTP Server.

#### Run

To run all mozmill tests you can run

```bash
make mozmill
```

Note that while the tests are running you shouldn't use keyboard/mouse at all, otherwise tests might fail erroneously.

Alternatively you could type the mozmill command manually, which allows you to specify a different `manifest.ini`. The above command is equivalent to:

```bash
mozmill --addon-manifests=${path_to_RP_source}/tests/mozmill/addon-manifest.ini -b ${path_to_firefox_bin} -m ${path_to_mozmill-tests_folder}/firefox/tests/addons/requestpolicy@requestpolicy.com/manifest.ini
```

### xpcshell

#### Getting and building firefox

To be able to run the xpcshell you need to build firefox. Be prepared for a long compilation time – up to one hour or even more. You can find build instructions [here](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions). Note that a `.mozconfig` file is not necessary. (If you already have your own firefox build, you don't need to rebuild of course.)

The commands I ran after fulfilling the prerequisites were:

```bash
# create a new directory where you want it
mkdir moz && cd moz

# get the source (also takes quite long)
hg clone https://hg.mozilla.org/mozilla-central/

cd mozilla-central/
./mach build
```

#### Creating a symlink

The bash scripts that are prepared for RP expect the `mozilla-central/` folder to be in the `/moz/` root directory. The easiest way is to create a symbolic link:

```bash
# replace ${MOZ_DIRECTORY} by the folder containing "mozilla-central"
sudo ln -is ${MOZ_DIRECTORY} /moz
```

#### Run

```bash
# run all of RP's xpcshell unit tests
tests/run-xpcshell-tests.sh

# run only one test by add the filename (without path) as the first argument
tests/run-xpcshell-tests.sh test_xyz.js
```