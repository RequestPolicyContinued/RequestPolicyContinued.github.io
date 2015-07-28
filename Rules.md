# Rules
<!-- HTMLTITLE Rules - RequestPolicy Continued -->

RequestPolicy **rules** combine 3 items:

 * The **origin** is a domain from where cross-site requests originate.
  * Commonly, this is the site you are currently browsing when the cross-site request is done.
 * A **destination** is the domain/group of domains that is the target of a cross-site request.
  * Commonly, this can be a CDN, a separate/special domain for static contents or scripts used on a site, or an advertising/metrics/statistics network.
 * The **policy** is the action that RequestPolicy will apply to a cross-site request, depending on it's origin and destination.
  * It can be _block_ or _allow_.

_Note: When both an allow and a block rule match a request, the user's default rule is used. (A priority system between rules is considered in [issue 491](https://github.com/RequestPolicyContinued/requestpolicy/issues/491))_

----------------------

## Origin and Destination

The origin and destination components of a rule can have the following properties. All properties are optional. An empty rule property will not be considered when matching against requests.

 * **Scheme:** The URL's scheme (protocol). For example, "http" or "https".
 * **Host:** The URL's host. For example, `example.com` (domain name), `192.30.252.128` (IPv4 address), or `fe80:0000:0000:0000:0202:b3ff:fe1e:8329` (IPv6 address).
  * _Note: For domain names, you can use a wildcard `*` to indicate any or no subdomain. For example, `*.example.com` will match `example.com`, `www.example.com`, or `a.b.c.example.com`. Wildcards are only supported as the leftmost label of a hostname. Wildcards are not supported anywhere else in the name and cannot be mixed with other characters._
  * **Port:** The URL's port. For example, `81` or `8080`. This may also be `*` to indicate that any ports should match. By default, rules that do not specify ports only match the default port for the request's scheme (eg. `80` for `http`).

