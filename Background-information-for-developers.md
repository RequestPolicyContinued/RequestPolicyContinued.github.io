# Background information for developers

The information provided on this page might be interesting for developers.

## extension IDs

There are two extension IDs in use, called _On-AMO_ and _Off-AMO_ ID. The __On-AMO__ ID is used for any release published on [AMO](https://addons.mozilla.org/en-US/firefox/addon/requestpolicy-continued/). As of the time I'm writing, only the v0.5 branch is offered on AMO, see issue [#543](https://github.com/RequestPolicyContinued/requestpolicy/issues/543). The __Off-AMO__ ID is used for [releases on GitHub](https://github.com/RequestPolicyContinued/requestpolicy/releases). It includes an [`updateURL`](https://developer.mozilla.org/en-US/Add-ons/Install_Manifests#updateURL) which points to [`update-1.x-beta.rdf`](https://github.com/RequestPolicyContinued/RequestPolicyContinued.github.io/blob/master/xpi/update-1.x-beta.rdf). The extra, off-AMO ID is needed due to [Extension Signing](https://wiki.mozilla.org/Addons/Extension_Signing).

## xpcshell

* Mozilla's xpcshell tests are run using `mach`. In order to run custom (e.g. RequestPolicy's) xpcshell unit tests, there are two possibilities: (a) integrate the tests into `mozilla-central`; (b) use `runxpcshelltests.py`. Option (b) seemed to be much easier to me.
