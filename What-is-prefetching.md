
## What is Prefetching?

There are three types of prefetching:

* _Link prefetching_ is where a web page tells your browser that you are likely to visit a certain page next so your browser should immediately request that next page even though you haven't actually gone there yet. More info at Mozilla's [Link Prefetching FAQ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Link_prefetching_FAQ).
* _DNS prefetching_ is where your browser tries to speed up future requests by resolving the IP address of every link on webpages you visit – just in case you decide to click on them. More info at Pat McManus' [DNS Prefetching blog post](http://bitsup.blogspot.de/2008/11/dns-prefetching-for-firefox.html).
* _Speculative pre-connections_ is where your browser opens predictive connections to sites, for example when the user hovers the mouse over a link. Besides that, a website can tell the browser to open such a pre-connection. More info at [this Mozilla Support page](https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_speculative-pre-connections), and at the [W3C "Resource Hints" Working Draft](http://www.w3.org/TR/resource-hints/#dfn-preconnect).

An example of Link prefetching is when searching with Google. Google search results pages will sometimes tell your browser to prefetch the first result from your search. Even if you decide not to click on that link, your browser still requested that page.

Unfortunately, with the way prefetching is currently implemented in Firefox, it is not possible to selectively block prefetch requests in the same way that other cross-site requests can be blocked. The only option is to disable prefetching completely.
