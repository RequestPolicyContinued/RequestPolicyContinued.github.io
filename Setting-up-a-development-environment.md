
# Setting up a development environment

Developing RequestPolicy requires some prerequisites. If you only want to build the XPI file, possibly with some changes, you need only a few things.

A full development environment, on the other hand, includes an environment for running all unit tests. In case of the full dev environment you'll need to prepare much more, so that I recommend you to create a chroot directory.

## Getting the Source Code

You will need:

* Git

```bash
sudo apt-get install git
```

---

We use `git` as our version control system. This is how to get the code:

```bash
git clone https://github.com/RequestPolicyContinued/requestpolicy.git
```

The command will create a directory called `requestpolicy`.


## Building the addon

You will need:

* [GNU Make](https://www.gnu.org/software/make/)
* [Zip](http://www.info-zip.org/Zip.html)
* [`preprocess.py`](https://code.google.com/p/preprocess/)

```bash
sudo apt-get install make zip preprocess
```

To build the XPI run

```bash
make
```


## Running Firefox and RP with Mozrunner

You will need:

* `virtualenv`

```bash
sudo apt-get install python-virtualenv
```

* Firefox Nightly

Download the file you need from [Mozilla's FTP server](https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-central/). Extract the files into `${rp_root_dir}/.mozilla/software/firefox/nightly/`. The binary file named `firefox` should be directly in that directory.

**Hint:** If you want, you could also install Fx Nightly elsewhere and create a symlink from `${rp_root_dir}/.mozilla/software/firefox/nightly/` to that directory.

When you're done:

```bash
make run
```


## Running unit tests

Setting up an environment for unit testing is optional. You probably won't need it if you do just a few changes to the code.

### xpcshell tests

#### Getting and building firefox

To be able to run the xpcshell you need to build firefox. Be prepared for a long compilation time – up to one hour or even more. You can find build instructions [here](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions). Note that a `.mozconfig` file is not necessary. (If you already have your own firefox build, you don't need to rebuild of course.)

This is what I ran in a chroot environment:

```bash
# create a new directory /moz
sudo mkdir /moz
cd /moz

# get the source (also takes quite long)
hg clone https://hg.mozilla.org/mozilla-central/
# alternatively you can use git:
# git clone https://git.mozilla.org/integration/gecko-dev.git mozilla-central

cd mozilla-central/
sudo ./mach bootstrap
./mach build
```

Run all tests:

```bash
./tests/run-xpcshell-tests.sh
```

### Marionette and MozMill

For both Marionette and MozMill tests you currently need to manually set up a Web Server (port 80) with PHP. The web server's root directory has to be `test/content/`.

Besides the Web Server, you need to create aliases for the Web Server. To do that, add the following new line to your `/etc/hosts` file:

```
127.0.0.1       maindomain.test www.maindomain.test sub-1.maindomain.test sub-2.maindomain.test otherdomain.test www.otherdomain.test sub-1.otherdomain.test sub-2.otherdomain.test thirddomain.test www.thirddomain.test sub-1.thirddomain.test sub-2.thirddomain.test
```

Not all of those domains are used at the moment, but they will, so add them all. By the way, `.test` is a [reserved TLD](https://en.wikipedia.org/wiki/.test).

### Marionette tests

TODO

### MozMill tests

You need:

* `virtualenv`

```bash
sudo apt-get install python-virtualenv
```

* the `mozmill-tests` repository

Instructions at [MDN](https://developer.mozilla.org/en-US/docs/Mozilla/QA/Mozmill_tests#Installing_Mozmill). Put the `mozmill-tests` directory into `${rp_root_dir}/.mozilla/`.

Run all mozmill tests:

```bash
make mozmill
```

This will automatically download the python packages into a virtualenv directory. Also, in the `mozmill-tests` folder, some symbolic links will be created.


---


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


---


## Developing Without Rebuilding the XPI (obsolete)

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
