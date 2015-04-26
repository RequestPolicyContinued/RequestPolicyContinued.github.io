
What is Prefetching?
← Back to main page

There are two types of prefetching:

    Link prefetching is where a web page tells your browser that you are likely to visit a certain page next so your browser should immediately request that next page even though you haven't actually gone there yet. More info at the Mozilla link prefetching FAQ.
    DNS prefetching is where your browser tries to speed up future requests by resolving the IP address of every link on webpages you visit (just in case you decide to click on them). More info at the Mozilla DNS prefetching FAQ.

An example of web page prefetching is when searching with Google. Google search results pages will sometimes tell your browser to prefetch the first result from your search. Even if you decide not to click on that link, your browser still requested that page.

Unfortunately, with the way prefetching is currently implemented in Firefox, it is not possible to selectively block prefetch requests in the same way that other cross-site requests can be blocked. The only option is to disable prefetching completely.

For more information on link prefetching in Mozilla browsers (such as Firefox), see the Mozilla link prefetching FAQ and Pat McManus' blog post.
