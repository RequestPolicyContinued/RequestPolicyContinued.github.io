## Risk of trusting subdomains

_Note: This does not apply if you untick `Allow requests to the same domain` in `Preferences > Manage policies > Default Policy`_

 * Subdomains are generally assumed to be owned by the same organization as the main domain. (eg. `images.example.com` is assumed to belong to the same organization as `www.example.com`). The general risk is that it is _possible_ for a site to direct traffic for a subdomain of theirs to a different company's IP address. This situation appears to be fairly uncommon at the current time, but is a real threat to privacy and is currently in use on various popular sites. The owner of `example.com` could point `cdn.example.com` to a content distribution network used on `example.com`, but that is actually owned by an other company (content delivery netowrks, analytics and tracking services...), or to direct traffic for `ads.example.com` to an other company that serves ads.
 * If you host `personal.example.com` on your local network, an attacker who controls `another.example.com` will be able to bypass RequestPolicy's _default deny_ policy for `personal.example.com`, as it does not apply to requests to the same domain.
 * An attacker that tricks you into visiting `www.evilsite.com` could point his subdomain `attack.evilsite.com` to the IP address of `your-bank.com`, thus the requests to the bank site will be allowed. However, your browser will not send cookies saved for `your-bank.com` to the attacker, as they do not have the same domain name. This makes the attack less useful in most situations.

