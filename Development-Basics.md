# Development Basics

## the source code

### getting the source code / building the addon

See [*Setting up a development environment*](Setting-up-a-development-environment) and [*Working with the Source Code*](Working-with-the-Source-Code).

### XPI files

For distribution, the source code is packaged into `.xpi` files. XPI files are just `zip` archives which you can extract like any other. However, if you want to work on the source code you should take the code from the repository, because the XPI's content and the code in the `src/` directory are not exactly the same.



## addon development basics

### XUL

RequestPolicy adds [XUL](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XUL) elements to every browser window, such as the menu button. There's a great [XUL Tutorial](https://developer.mozilla.org/en-US/Add-ons/Overlay_Extensions/XUL_School) on MDN.

### XPCOM

When developing Mozilla Add-Ons you will stumble upon [XPCOM](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM) components:

* [Creating XPCOM components](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Guide/Creating_components)
* [JavaScript-specific guide](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Guide/Building_components_in_JavaScript)

### Development tools

There are some very useful tools for developing addons. To name some of them:

* the [Browser Toolbox](https://developer.mozilla.org/en-US/docs/Tools/Browser_Toolbox) and other [Firefox Developer Tools](https://developer.mozilla.org/en-US/docs/Tools) – to debug extensions
* the [DOM Inspector](https://addons.mozilla.org/en-US/firefox/addon/dom-inspector-6622/) and [Inspect Context](https://addons.mozilla.org/en-US/firefox/addon/inspect-context/) – inspect, browse, and edit the DOM of XUL windows



## source code basics

The main source code lives in the `src/` directory, unit tests in `tests`.

### programming language

RequestPolicy is written in JavaScript. Some unit tests (Marionette) are written in Python.

### entry points

When the addon is installed, the files `install.rdf` and `chrome.manifest` are parsed and `bootstrap.js` is executed. More infos:

* `install.rdf`: [docs](https://developer.mozilla.org/en-US/Add-ons/Install_Manifests). It specifies the addon's ID, name, description and version string, as well as the web browsers' `minVersion` and `maxVersion`.
* `chrome.manifest`: [docs](https://developer.mozilla.org/en-US/docs/Chrome_Registration), [tutorial](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XUL/Tutorial/Manifest_Files). It specifies the `chrome://rpcontinued/` URI.
* `bootstrap.js`: [docs](https://developer.mozilla.org/en-US/docs/Extensions/bootstrap.js)

From `bootstrap.js` RequestPolicy is started up.

### „Content Policy“ implementation

RequestPolicy's blocking functionality bases mostly on the [`nsIContentPolicy`](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Reference/Interface/nsIContentPolicy) interface. RequestPolicy implements this interface by an XPCOM component. The component's [`shouldLoad`](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Reference/Interface/nsIContentPolicy#shouldLoad%28%29) function will be called for each request to decide whether or not the resource at a given location should be loaded.



## general topics

### URIs

Each request has a destination URI, and often also an origin URI. For information about about URIs see [STD 66](http://tools.ietf.org/html/std66) (Internet standard) – especially [Appendix A](http://tools.ietf.org/html/std66#appendix-A). There's also some information on [wikipedia](https://en.wikipedia.org/wiki/URI_scheme#Generic_syntax).

This is the [ABNF](https://en.wikipedia.org/wiki/Augmented_Backus%E2%80%93Naur_Form) definition of an URI:

```
scheme ":" hier-part [ "?" query ] [ "#" fragment ]
```

The „scheme“ often is `http` or `https`. The „hier-part“ normally is the host in the form of `//www.example.com` or `//127.0.0.1`.

### domain names and the „Public Suffix List“

RequestPolicy treats domain names either as full domains (e.g. `www.example.com`) or regarding their „Base Domain“ (e.g. `example.com`). The Base Domain is determined using the „Public Suffix List“ ([wikipedia](https://en.wikipedia.org/wiki/Public_Suffix_List), [publicsuffix.org](https://publicsuffix.org/)). Therefore, for example, the Base Domain of `xyz.cloudfront.net` is equally `xyz.cloudfront.net`, not `cloudfront.net`.

### security

Have a look at the MDN articles [Security check basics](https://developer.mozilla.org/en-US/docs/Security_check_basics) and [Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy)



## Glossary

- `ruleset`: a list of *rules*. can be empty.
- `rule`: contains some selection specification (e.g. `origin` and `destination`) and a `policy`
- `policy`: whether requests matching a rule are *allowed* or *blocked*



## Abbreviations

The following abbreviations are used

- `RP`: RequestPolicy; `RPC`: RequestPolicy Continued
- `Fx`: Firefox
- `e10s`: Electrolysis (aka multiprocess firefox)



## about:config configuration settings

Here is a list of RequestPolicy's settings that can be edited by going to `about:config` in the address bar, along with their descriptions, defaults and possible values (TODO):

 * `extensions.requestpolicy.autoReload`
 * `extensions.requestpolicy.contextMenu`
   * Boolean; if RequestPolicy should put an entry in the content-area context menu
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
