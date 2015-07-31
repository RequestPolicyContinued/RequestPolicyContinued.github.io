# Detailed documentation of some topics


## The „Environment System“

**TODO:** Update this chapter. It's partly obsolete since commit [`355cf5d`](https://github.com/RequestPolicyContinued/requestpolicy/commit/355cf5d61126262c9b22ccf3b018ee78bca6ef9d).

RequestPolicy has a class called `Environment` which can be used from anywhere. A new environment is created via

```javascript
let env = new Environment("my environment");
```

To each instance of `Environment`, `startup` and `shutdown` functions can be added. This means that the `Environment` class helps to manage tasks that have to be done when an environment is created or destroyed. When the Environment is about to start up, all registered startup functions will be called; same with shutdown.

*By the way*, it is possible to add startup and shutdown functions at any time. If a startup function is added when the Environment is already up and running, that function will be called immediately.

To have some more control, there are different startup/shutdown levels: `ESSENTIAL`, `BACKEND`, `INTERFACE` and `UI`. To know for what each of them is used, please refer to the code.

### Environment Managers
`EnvironmentManager` is a JavaScript module which – as the name says – manages environments. Each `Environment` imports the Environment Manager and registers itself on the Environment's startup. Similarly, the Environment *unregisters* itself when it shuts down. Note that because of the nature of JavaScript modules, there will be one Environment Manager for each process.

`EnvironmentManager` enables to shut down all registered Environments at once. This is needed when the addon gets disabled (RP is a [bootstrapped extension](https://developer.mozilla.org/en-US/Add-ons/Bootstrapped_extensions)). More specifically, the main process' Environment Manager's `startup` and `shutdown` functions are called by `bootstrap.js`. The child Environment Managers on the other hand will listen to the shutdown **message** (see [MessageManager](https://developer.mozilla.org/en-US/Firefox/Multiprocess_Firefox/The_message_manager)).

### Startup and Shutdown

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

### Special environments

#### Process Environments
Many modules define startup and shutdown functions. Most modules attach those functions to the *Process Environment*. That's a small module which simply creates a new Environment once it's called.

#### Frame Script Environments
Frame scripts are needed to support Electrolysis (abbr. e10s; codename for [Multiprocess Firefox](https://developer.mozilla.org/en-US/Firefox/Multiprocess_Firefox)). RequestPolicy loads a frame script into each tab of each browser window, regardless of whether Electrolysis is enabled or not.

Special attention needs to be given to the fact that even when Electrolysis is enabled there might still be tabs which are in the *main* process. So if a new Environment is created in the framescript's scope, it will be managed by either the main process' or the child process' `EnvironmentManager`. However, the frame script will create its own environment only if it's in the main process; framescripts in child processes can use the Process Environment. The reason is that also the framescript imports some JavaScript modules, and those modules might add startup functions to the Process Environment as well. This way the frame script needs to manage only one instead of two Environments in the child process.

So the summary of the framescript's startup process is:
- Import the Environment Manager
- determine the FrameScript Environment
  - child process: use Process Environment
  - parent process: create a new Environment
- call the Environment Manager's `registerFramescript()` function. The Environment Manager will then listen to the "shutdown" message, which will be sent from the main process.

The shutdown works the same as in the main process,
