## Security benefits of using RequestPolicy


_Warning: When using RequestPolicy with the [default policy](quickstart#Setting-up---default-policy) being `Allow`, you won't be protected from the attacks/techniques described above!_

#### Cross-Site Request Forgery

Cross-Site Request Forgery (CSRF) is an attack that takes advantage of the fact that a website that receives a request from your browser may not be able to tell that you, the human user, didn't actually intend to make that request. When you are at a website, say evil-site.com, the content of the page that you are viewing can tell your browser to make a request to your-bank.com. When your-bank.com receives the request, it may not know that you didn't really intend to make that request! Other types of CSRF attacks also exist. Some join the victim to an attacker's session. Some cause the client to download illegal/unwanted/unethical/embarrassing content.

How can you stay safe against CSRF attacks? Until now, protecting against CSRF attacks required the user to trust that every website protects itself against CSRF attacks (and, of course, many don't). Users had very limited ability to protect themselves (e.g. always logging out of services that require login, not being logged into two websites simultaneously, or using completely separate browsers or browser instances for different websites). These protections, however, were only effective in certain cases. RequestPolicy allows you to protect yourself. With RequestPolicy, cross-site requests are disallowed unless you choose to allow them. You won't have to just hope that you don't fall victim to CSRF attacks -- you'll be safe.

#### Clickjacking

Clickjacking is a malicious technique of tricking a Web user into clicking on something different from what the user perceives they are clicking on. A clickjacked page tricks a user into performing undesired actions by clicking on a concealed link. In most cases, clickjacking attacks require that a malicious (or exploited) website be able to load other websites in IFRAMEs (small browser windows embedded within the main browser window). RequestPolicy protects you from these types of attacks because including those IFRAMEs from other sites will not be allowed unless you explicitly allow them. So, for example, if you are on evil-site.com, the evil-site.com webpage will not be able to tell your browser to load a page from your-bank.com unless you choose to allow that.

#### Network attacks and scans

Using RequestPolicy will also help prevent your browser from being used with various types of network attacks and network scanning. For example, if a website you visit tries to use your browser to perform a scan of your local network, those requests will be blocked.