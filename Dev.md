# RequestPolicy Development Wiki
<!-- HTMLTITLE Development - RequestPolicy Continued -->

Welcome to the RequestPolicy Development Wiki! This wiki is intended to encourage more
people to become RequestPolicy developers and contributors. This documentation is by far not complete, so if you have an idea for an addition, a change or a removal, please let us know.

Note that if you're having an idea for RequestPolicy, please talk about it in the issue tracker.
What you shouldn't do is spending months implementing a feature in silence and then find yourself disappointed if we don't want to merge your changes. This would be frustrating for you, the other developers, and the RequestPolicy users.

Getting started with RequestPolicy development:

 * [Setting up a development environment](Setting-up-a-development-environment)
 * [Working with the source code](Working-with-the-Source-Code) 

You will find some information about RequestPolicy below. 

## Links

- [Current development](https://github.com/RequestPolicyContinued/requestpolicy/issues)
- [Thread on mozillazine](http://forums.mozillazine.org/viewtopic.php?f=48&t=1051805)
- [Reviews of RP 0.5](https://addons.mozilla.org/en-US/firefox/addon/requestpolicy/reviews/)
- [Google Group for the original RP](https://groups.google.com/d/forum/requestpolicy-discuss)

## Help and support for users and developers

So you are using RequestPolicyContinued? Great! Have a look at the project's [website](https://requestpolicycontinued.github.io/), which contains some information. If you have any questions or ideas, feel free to leave a comment [in our general discussion thread](https://github.com/RequestPolicyContinued/requestpolicy/issues/484) or create a [new issue](https://github.com/RequestPolicyContinued/requestpolicy/issues/new).

## Getting the Source Code

If you'd like to download the RequestPolicy source code from our version control system, you can do so with:

`git clone https://github.com/RequestPolicyContinued/requestpolicy.git`

## Building the XPI Firefox addon

Before building you need to install [GNU Make](https://www.gnu.org/software/make/) as well as the npm package [preprocessor](https://www.npmjs.com/package/preprocessor). On a debian-based system you could run:

    sudo apt-get install make npm
    sudo npm install -g preprocessor

After preparation, run `make` from the repository's root directory. The XPI file will be created at `dist/requestpolicy.xpi` and can be used for easy installation of RP into your web browser (e.g. Firefox).

## Good to know

- As a starting point you might have a look at RP's *manifest.ini* (→[tutorial](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XUL/Tutorial/Manifest_Files); [more info on chrome registration](https://developer.mozilla.org/en-US/docs/Chrome_Registration)).
- RequestPolicy implements an [XPCOM](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM) component (→[general tutorial](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Guide/Creating_components), [JavaScript-specific guide](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Guide/Building_components_in_JavaScript)) to intercept requests (see [nsIContentPolicy.shouldLoad()](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Reference/Interface/nsIContentPolicy#shouldLoad%28%29)).
- Have a look at the MDN articles [Security check basics](https://developer.mozilla.org/en-US/docs/Security_check_basics) and [Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy)
- RequestPolicy adds [XUL](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XUL) elements to every browser window, such as the menu button.
- **"Base Domain":** RP uses the *Public Suffix List*. See also:
  - http://en.wikipedia.org/wiki/Public_Suffix_List
  - https://publicsuffix.org/
- **URI and URI schemes:** See [STD 66](http://tools.ietf.org/html/std66) (Internet standard) – especially [Appendix A](http://tools.ietf.org/html/std66#appendix-A) – and [wikipedia](https://en.wikipedia.org/wiki/URI_scheme).
- ...

## Detailed information on some topics


### The „Environment System“

**TODO:** Update this chapter. It's partly obsolete since commit [`355cf5d`](https://github.com/RequestPolicyContinued/requestpolicy/commit/355cf5d61126262c9b22ccf3b018ee78bca6ef9d).

RequestPolicy has a class called `Environment` which can be used from anywhere. A new environment is created via
```javascript
let env = new Environment("my environment");
```
To each instance of `Environment`, `startup` and `shutdown` functions can be added. This means that the `Environment` class helps to manage tasks that have to be done when an environment is created or destroyed. When the Environment is about to start up, all registered startup functions will be called; same with shutdown.

*By the way*, it is possible to add startup and shutdown functions at any time. If a startup function is added when the Environment is already up and running, that function will be called immediately.

To have some more control, there are different startup/shutdown levels: `ESSENTIAL`, `BACKEND`, `INTERFACE` and `UI`. To know for what each of them is used, please refer to the code.

#### Environment Managers
`EnvironmentManager` is a JavaScript module which – as the name says – manages environments. Each `Environment` imports the Environment Manager and registers itself on the Environment's startup. Similarly, the Environment *unregisters* itself when it shuts down. Note that because of the nature of JavaScript modules, there will be one Environment Manager for each process.

`EnvironmentManager` enables to shut down all registered Environments at once. This is needed when the addon gets disabled (RP is a [bootstrapped extension](https://developer.mozilla.org/en-US/Add-ons/Bootstrapped_extensions)). More specifically, the main process' Environment Manager's `startup` and `shutdown` functions are called by `bootstrap.js`. The child Environment Managers on the other hand will listen to the shutdown **message** (see [MessageManager](https://developer.mozilla.org/en-US/Firefox/Multiprocess_Firefox/The_message_manager)).

#### Startup and Shutdown

The startup sequence is as follows:
- The `startup` function in `bootstrap.js` gets called by the browser
- `bootstrap.js` calls `Environment Manager.startup()`
- The Environment Manager …
  - does some **essential tasks** which are necessary for bootstrapped extensions
  - **loads main modules** which again load more modules. Any of those loaded modules might add startup functions to the Process Environment.
  - starts up the Process Environment. No other Environments are started up explicilty, they have to be started up elsewhere.

The shutdown sequence is quite similar:
- The `shutdown` function in `bootstrap.js` gets called by the browser
- `bootstrap.js` calls `Environment Manager.shutdown()`. This is the main process' Environment Manager, as `bootsrap.js` is in the main process.
- The Environment Manager tells all Environments to shut down.

#### Special environments

##### Process Environments
Many modules define startup and shutdown functions. Most modules attach those functions to the *Process Environment*. That's a small module which simply creates a new Environment once it's called.

##### Frame Script Environments
Frame scripts are needed to support Electrolysis (abbr. e10s; codename for [Multiprocess Firefox](https://developer.mozilla.org/en-US/Firefox/Multiprocess_Firefox)). RequestPolicy loads a frame script into each tab of each browser window, regardless of whether Electrolysis is enabled or not.

Special attention needs to be given to the fact that even when Electrolysis is enabled there might still be tabs which are in the *main* process. So if a new Environment is created in the framescript's scope, it will be managed by either the main process' or the child process' `EnvironmentManager`. However, the frame script will create its own environment only if it's in the main process; framescripts in child processes can use the Process Environment. The reason is that also the framescript imports some JavaScript modules, and those modules might add startup functions to the Process Environment as well. This way the frame script needs to manage only one instead of two Environments in the child process.

So the summary of the framescript's startup process is:
- Import the Environment Manager
- determine the FrameScript Environment
  - child process: use Process Environment
  - parent process: create a new Environment
- call the Environment Manager's `registerFramescript()` function. The Environment Manager will then listen to the "shutdown" message, which will be sent from the main process.

The shutdown works the same as in the main process, 


## Glossary

- `ruleset`: a list of *rules*. can be empty.
- `rule`: contains some selection specification (e.g. `origin` and `destination`) and a `policy`
- `policy`: whether requests matching a rule are *allowed* or *blocked*

## Abbreviations

The following abbreviations are used

- `RP`: RequestPolicy; `RPC`: RequestPolicy Continued
- `Fx`: Firefox
- `e10s`: Electrolysis (aka multiprocess firefox)
- …


## about:config configuration settings

Here is a list of RequestPolicyContinued settings that can be edited by going to `about:config` in the address bar, along with their descriptions, defaults and possible values (TODO):


 * `extensions.requestpolicy.autoReload`
 * `extensions.requestpolicy.defaultPolicy.allow`
 * `extensions.requestpolicy.defaultPolicy.allowSameDomain`
 * `extensions.requestpolicy.indicateBlacklistedObjects`
 * `extensions.requestpolicy.indicateBlockedObjects`
 * `extensions.requestpolicy.initialSetupDialogShown`
 * `extensions.requestpolicy.lastAppVersion`
 * `extensions.requestpolicy.lastVersion`
 * `extensions.requestpolicy.log`
 * `extensions.requestpolicy.log.level`
 * `extensions.requestpolicy.log.types`
 * `extensions.requestpolicy.menu.info.showNumRequests`
 * `extensions.requestpolicy.menu.sorting`
 * `extensions.requestpolicy.prefetch.dns.disableOnStartup`
 * `extensions.requestpolicy.prefetch.dns.restoreDefaultOnUninstall`
 * `extensions.requestpolicy.prefetch.link.disableOnStartup`
 * `extensions.requestpolicy.prefetch.link.restoreDefaultOnUninstall`
 * `extensions.requestpolicy.privateBrowsingPermanentWhitelisting`
 * `extensions.requestpolicy.startWithAllowAllEnabled`
 * `extensions.requestpolicy.welcomeWindowShown`