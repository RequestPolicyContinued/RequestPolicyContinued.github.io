# Background information for developers

The information provided on this page might be interesting for developers.

## xpcshell

* Mozilla's xpcshell tests are run using `mach`. In order to run custom (e.g. RequestPolicy's) xpcshell unit tests, there are two possibilities: (a) integrate the tests into `mozilla-central`; (b) use `runxpcshelltests.py`. Option (b) seemed to be much easier to me.
