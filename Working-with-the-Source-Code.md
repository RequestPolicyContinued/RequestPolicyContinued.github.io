# Working with the source code
<!-- HTMLTITLE Working with the Source Code - RequestPolicy Continued -->

After setting up a [development environment](Setting-up-a-development-environment) you can start tinkering with the code.

## using the Browser Toolbox (debugging extensions)

If you have no experience in developing extensions for mozilla applications, you might have a look at the [Browser Toolbox](https://developer.mozilla.org/en-US/docs/Tools/Browser_Toolbox) and other [Firefox Developer Tools](https://developer.mozilla.org/en-US/docs/Tools).

## changing the version string

To change the RequestPolicy version number, edit the file `src/install.rdf` and, for example, change:

```xml
<em:version>0.5.23</em:version>
```

to:

```xml
<em:version>0.5.23-yourname1</em:version>
```

Now restart Firefox (the instance running your development profile you've set up)
and check `about:addons` to verify that the new version number is shown there.

## changing minVersion and maxVersion

A problem you could hit is that your version of Firefox is not supported by RequestPolicy (or, at least, is not supported by the particular RequestPolicy code you're starting development with). If necessary, you can force RequestPolicy to work with your version of Firefox by editing the file `src/install.rdf` and changing the values of minVersion or maxVersion.