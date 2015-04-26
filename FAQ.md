## Frequently Asked Questions

<!-- MarkdownTOC -->

- [Limitations - What RequestPolicy Continued cannot help with](#limitations---what-requestpolicy-continued-cannot-help-with)
- [Which kinds of requests are blocked?](#which-kinds-of-requests-are-blocked)
- [How are sites classified as "third-party sites"?](#how-are-sites-classified-as-third-party-sites)
- [What changes to my browser are left behind after uninstalling RequestPolicy?](#what-changes-to-my-browser-are-left-behind-after-uninstalling-requestpolicy)
- [Can websites detect that you are using RequestPolicy?](#can-websites-detect-that-you-are-using-requestpolicy)
- [Other browser addons](#other-browser-addons)
- [The flag icon is red! What is wrong?](#the-flag-icon-is-red-what-is-wrong)
- [How to deal with ajax.googleapis.com?](#how-to-deal-with-ajaxgoogleapiscom)
- [How to find relevant information about a bug](#how-to-find-relevant-information-about-a-bug)

<!-- /MarkdownTOC -->


---------------------------------------

### Limitations - What RequestPolicy Continued cannot help with

#### Browser plugins

It's important to understand that RequestPolicy can only stop requests that the browser knows about. It is possible for browser plugins such as Flash, Java, and Silverlight to bypass the web browser in making requests. Even though some requests made by these plugins are controlled by RequestPolicy, it's good to be aware that third-party plugins such as these may bypass the browser and, therefore, also bypass RequestPolicy.

#### Javascript-based attacks

In addition to disallowing these plugins by default, there are also plenty of security reasons to disallow JavaScript on websites you visit unless you are sure you want to allow it. To help you control when plugins and JavaScript run on website you visit, we suggest using the NoScript Firefox extension. Using NoScript in addition to RequestPolicy will give you a highly secure browser. 

#### HTTP Referer headers

When you follow a link from one page or site to another, your browser sends a Referer HTTP header to the server to tell the tagret site where you came from. Some sites abuse this information to violate visitors’ privacy and track them across the Web. In Firefox, you can disable the sending of the Referer header, or alter the information that is sent, using addons such as Smart Referer or RefControl.

<sup>You can also manually alter what information is sent through the HTTP Referer header by going to `about:config` and tweaking the `network.http.referer.XOriginPolicy`, `network.http.referer.spoofSource`, `network.http.referer.trimmingPolicy` and `network.http.sendRefererHeader` preferences.</sup>

---------------------------------------

### Which kinds of requests are blocked?

By default, any request the browser makes from the current site a user is on to a third-party site is blocked. Users can then whitelist specific sites (with various levels of granularity) to allow requests they approve of.
Request that are blocked include:

   * **Content of the current page that is from a different site:** Various tags in an HTML page tell the browser that more content is needed to display the current page. Normally, the browser immediately makes requests to third-party sites to obtain this content. The content can include images, JavaScript files, style sheet files, and many others.
   * **Redirections** from the current site to a different site: Redirects tell your browser to load an entirely different website address than the one you are on or requested. Redirections can be caused by JavaScript, META refresh tags, and on headers.
   * Content a page tells your browser to "prefetch": Some browsers, such as Firefox, allow any webpage to tell your browser to load other pages in the background. This is intended to allow a website to improve your browsing experience by guessing which pages you are likely to visit next so that those pages will load faster when you visit them. In Firefox 3.1, DNS prefetching was also added. DNS prefetching is where your browser tries to speed up future requests by resolving the IP address of every link on webpages you visit (just in case you decide to click on them). [Read more about prefetching...](What-is-prefetching)

_Note that **OCSP queries and CRL updates** are not blocked. This means that RequestPolicy will not interfere with your browser's attempts to determine whether SSL certificates have been revoked._

---------------------------------------

### How are sites classified as "third-party sites"?

A site is considered a third-party site if its registered domain name is different than the registered domain of the page that initiated the request. For example, the domains: `example.com, www.example.com, a.b.c.example.com` All have the same registered domain name (`example.com`) and so are considered the same site.

_There is some risk posed by this default, but this level of granularity is the one with the optimal tradeoff of usability for privacy and security according to the needs of most users. Read [Risk of trusting subdomains](Risk-of-trusting-subdomains) and untick `Allow requests to the same domain` if you want protection against attacks that use subdomains._

---------------------------------------

### What changes to my browser are left behind after uninstalling RequestPolicy?

By default, when you uninstall or disable RequestPolicy, all changes RequestPolicy made to your browser's settings will be undone. Primarily this means that your default prefetching settings are restored to the browser's default settings. That is, DNS and link prefetching will be re-enabled when you uninstall RequestPolicy.

However, if you have gone to RequestPolicy's preference window and under the Advanced preferences you have disabled the options to Restore default when RequestPolicy is uninstalled, then your browser's default prefetch settings will not be restored when you disable or uninstall RequestPolicy.

_Privacy note: RequestPolicy will leave various RequestPolicy-specific settings and configuration files in your browser profile even after it has been uninstalled. For example, your whitelist will still be available to other people who have access to your computer. This is a known bug (see ticket #227). A future version of RequestPolicy will attempt to delete all RequestPolicy whitelist data, etc., when RequestPolicy is uninstalled. In the mean time, if you are looking to remove all RequestPolicy-related files and configurations, you should go to the page about:config in your browser and "reset" every preference that starts with "extensions.requestpolicy". Starting with RequestPolicy version 0.6, you also should delete the "requestpolicy" directory which was created in your browser's profile directory (if you used multiple browser profiles, you will need to locate the one where you had installed RequestPolicy). If you have questions about verifying that you have correctly removed RequestPolicy data, please don't hesitate to contact us._

---------------------------------------

### Can websites detect that you are using RequestPolicy?

Yes. It may be possible for a website to detect that a user has RequestPolicy installed. The website can look at which cross-site requests are blocked and make an educated guess that RequestPolicy is doing the blocking.

More generally, a browser fingerprinting risk exists for users of any extension that modifies the behavior of the web browser on a web page or the content of the web page itself. Check Panopticlick from the Electronic Frontier Foundation to see what browser fingerprinting can reveal about you

---------------------------------------

### Other browser addons

#### Is there a RequestPolicy for Chrome?

Not yet. However you can use https://github.com/gorhill/uMatrix which offers similar functionality.



#### Is RequestPolicy an alternative or competitor to NoScript?

No! :) NoScript is a tool that gives you a default deny policy for JavaScript, Java, Flash and other plugins. NoScript allows you to whitelist scripts and objects from domains you trust.

RequestPolicy is a tool that gives you a default deny policy for cross-site requests. RequestPolicy allows you to whitelist cross-site requests you trust.

RequestPolicy will protect you from various attacks that NoScript will not (such as CSRF attacks, though there some special cases that NoScript protects against) and will give you greater privacy while browsing.

Also, RequestPolicy will give you finer-grained control over JavaScript and plugins when you use it with NoScript. For example, if you whitelist a domain with NoScript to allow it to run JavaScript, then that domain will also be allowed to run JavaScript when you are on any other site that you have whitelisted with NoScript. RequestPolicy makes sure that when it is JavaScript from a third-party site, it will still be restricted unless you have allowed those cross-site requests.

Conversely, NoScript gives you protection that RequestPolicy does not. RequestPolicy will not keep you safe from malicious JavaScript or vulnerable plugins on the current site you are visiting, So, NoScript is absolutely essential for browser security.

Having two separate tools that each do their specific jobs well is the best approach. NoScript is an amazing extension and is absolutely essential (like RequestPolicy) to using Firefox securely. It is best to use both RequestPolicy and NoScript.

#### Other browser addons you may be interested in

Some addons for Firefox can enhance your privacy and security when browsing the Web. For a list of quality addons, check [PRISM Break's list of browser addons](https://prism-break.org/en/all/#web-browser-addons).

---------------------------------------

### The flag icon is red! What is wrong?

Nothing (on your side) is wrong. RequestPolicy is actually doing it's job by blocking requests to other sites you didn't explicitely request. The website you're visiting is actually trying to force you to request data from other sites, which may be wrong for [privacy](Privacy) and [security](Security) reasons. You will need to allow automatically or manually these requests if the blocking breaks viewing the site. [Learn how to use RequestPolicy now...](Quickstart)

---------------------------------------

### How to deal with ajax.googleapis.com?

Many sites depend on jQuery served by Google

  * Clear cookies regularly with addons like Self-Destructing Cookies
  * Spoof your referer with SmartReferer to prevent ajax.googleapis.com from knowing what page you visit when the request is done
  * Use your hosts file to redirect requests to jquery.js to a local file or a domain you control.
  * Ask the site administrator to host their js libs themselves (eg. reddit.com has an option for this)
  * Contribute to [subscriptions](https://github.com/RequestPolicyContinued/subscriptions) to add a rule for sites that absolutely require calls to ajax.googleapis.com
  * Take the time to allow the request if necessary, or live with the broken site. RequestPolicy is about user control on cross-site requests.

---------------------------------------

### How to find relevant information about a bug

Sometimes a bug is not easily reproducible. You need to make the bug is caused by RequestPolicy Continued itself, not by another addon or incorrect configuration setting. Please do the following:

 * Create a [new, blank profile in Firefox](https://support.mozilla.org/en-US/kb/profile-manager-create-and-remove-firefox-profiles), with no addons installed.
 * Install the latest RequestPolicy Continued from https://github.com/RequestPolicyContinued/requestpolicy/releases
 * Navigate to your test page and try to reproduce the bug.

If the problem still occurs with this setup, it is likely a RequestPolicy bug. If the addon works as expected with a blank Firefox profile, then something in your "regular" Firefox profile is causing this bug (another addon or preference). If so, please try the following:

  1. Start your normal Firefox profile.
  2. Disable all addons, except RequestPolicy Continued. (you may need to restart Firefox)
  3. Go to your test page, confirm that RequestPolicy works normally.
  4. Re-enable another addon (just one), restart Firefox if needed, reload the test page.
  5. If the bug stll not shows up, the addon you just enabled is not causing it.
  6. Redo step 4 (enable another addon, restart Firefox if needed, reload the test page.) until you find the addon that is causing the bug to occur, and please report the addon name here.

If disabling all addons didn't help, you can do the following:

 * Check firefox' browser console
 * [Enable RPC's logging](Setting-up-a-development-environment#enable-logging) and start Fx from the terminal