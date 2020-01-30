title: "DApp Frontend Security"
summary: "Security is not just a consideration for DApp Backend Developers, but for Frontend Developers too.  In this article we'll cover a comprehensive security strategy for DApp Frontends."
author: robin_percy
categories:
  - tutorials
layout: blog-post
image: '/assets/images/web3-article-header.png'

---

![Web3.js](/assets/images/web3-article-header.png)


## Introduction

*This article is the second in my series of articles based on the frontend of the web.  We'll look at [Web3.js](/news/2019/12/09/web3-what-are-your-options/) & accessing the Ethereum Blockchain client-side, frontend to backend security for DApps,  how WebAssembly has become the "4th language of the web", and we'll build a realtime Blockchain explorer app in Phoenix LiveView!*

Working for a [security-focused company like Status](https://status.im/security/) means that security, in its many forms, is mentioned on a daily basis. 

However; outside of [Status](http://status.im) one of the broadest, most important, yet often ignored considerations when deploying and running web applications is the security of the app.  When I use the term _security_,  I’m not just speaking from a Back end perspective, but also of the Front end of the application.  Having good infrastructure security is highly important, but there are also security factors on the front end of the application that we really _must_ take into account.

Security is an ongoing, and ever-changing, practice that you must observe to ensure that your product is never included in the companies that one hears about on the news after a huge data breach. Regardless of which programming paradigm, language or framework you wish to use, there are plenty of non-specific, terse security practices you should follow from the very start of the project.

In my last personal Startup, we provided User Authentication as a Service, so we were a major target for hackers. On one of our first evenings live, we watched someone attempt to send 5million malicious requests within 30 minutes. None of which had any affect other than exposing the hacker. This is because we made security a priority — which is something we all need to do in the modern world of Tech.

In this article, I'll introduce you to my biggest tips for top to bottom (Front end to Back end) security for your web applications.  We'll take a look at security for your DApps too!


## Strict Transport Security (HSTS)

HSTS is a security header that allows us to enforce HTTPS across our entire Web App.  If you read my previous article, you'll remember I advocate the idea of HTTPS everywhere, and showed you how to get a trusted, secure SSL certificate free-of-charge from [Let's Encrypt](https://letsencrypt.org).  The reason we need HTTPS everywhere is that our users are vulnerable to Cookie stealing and Man-in-the-middle attacks if we don't have it implemented.

Now, as you're probably aware, simply owning an SSL Cert will *not* immediately make all of your Web App HTTPS only - we need to tell our App to do that, ourselves.  One of the best ways of doing this is by using the HTTP Header of HSTS.  By using this Header, we can force all traffic on our App to use HTTPS and upgrade non-HTTPS.  This Header may also even provide a performance ***boost***, as we no longer would have to send our users through a manual redirect.

So, you're probably thinking "Wow! I need this!".  Well, whilst I agree - alongside the *Content Security Policy* I'll talk about later, this needs to be implemented **with caution.**  Allow me to explain!  Here's what a sample HSTS Header looks like:

	Strict-Transport-Security: max-age=630720; includeSubDomains; preload

*And in Node.js:*

```js
function requestHandler(req, res) {
	res.setHeader('Strict-Transport-Security', 'max-age=630720; includeSubDomains; preload');
}
```

In this Header, we have 3 *directives* that apply.  `max-age`, `includeSubDomains` and `preload`.

***max-age***:  By specifying a max-age, we are telling the user's browser to cache the fact that we use only HTTPS.  This means that if the user tries to visit a non-HTTPS version of the site, their browser will be automatically redirected to the HTTPS site, *before* it even sends a message to the Server.  Therein lies the slight performance boost I mentioned earlier.  Now, while this *does* sound fantastic in theory, what we need to be aware of here, is the fact that if a user ever *needed* to access a non-HTTPS page, their browser simply won't let them, until this `max-age` expires. If you are going to activate this feature, and set a long `max-age`, (required by the pre-load sites I'll talk about in a second), you ***really*** need to be sure that you have your SSL cert setup correctly, and HTTPS enabled on *all* of your Web App before you take action!

***includeSubDomains***:  The `includeSubDomains` directive does exactly what it says on-the-tin.  It simply offers additional protection by enforcing the policy across your subdomains too.  This is useful if you run a Web App that sets Cookies from one section (perhaps a gaming section), to another section (perhaps a profile section), that need to be kept secure.  Again, the issue with this lies similarly to the above, in that you ***must*** be sure *every* subdomain you own and run, is entirely ready for this to be applied.

***preload***:  The most dangerous directive of them all!  Basically, the `preload` directive is an in-browser-built directive that comes straight from the browser creators. This means that your Web App can be hard-coded into the actual *Browser* to always use HTTPS.  Again, whilst this would mean no redirects, and therefore a performance boost, once you're on this list; it's ***very*** difficult to get back off it!  Considering that Chrome takes around 3 months from build-to-table, and that's only for the people who auto-update, you've got a *huge* wait-time if you make a mistake.

So we have ourselves here an incredibly powerful, yet actively quite dangerous Security feature.  The key here is ensuring you **know** your security measures inside-out, and using  discretion.  Whilst I don't recommend you submit your site to the `preload` directive, if you wish to - you [can here](https://hstspreload.org/).

**Note** - it is *not* a requirement to use preload to utilise HSTS.  The only Header you need apply is the max-age header.

If you are going to use the HSTS protocol, start out with a small `max-age` - something like a few hours, and continue to ramp it up over a period of time.  This is also the advice Google Chrome give.  If you use the `includeSubDomains` directive, be sure you don't have internal (company.mysite.com) subdomains that would be unreachable if affected.  If you're going to submit your Web App to `preload`, follow the official guidelines, and make sure you know exactly what you're doing - (which I'm not entirely confident of myself!)


## Using the X-XSS-Protection Header

XSS (Cross Site Scripting) is the most common of all Web App attacks.  XSS occurs when a malicious entity injects scripts to be run into your Web App.  A few years back, most web browsers added a security filter for XSS attacks built into the browser itself.  Now whilst in theory this was a good step, they did tend to throw-up false-positives quite often.  Due to this, the filter can be turned off by the User. (As the option should be available, in my opinion.)

To ensure our Users are protected, we can force this filter (worth it), on our Web App by using the `X-XSS-Protection` Header.  This Header is widely supported by common browsers, and something I'd recommend using every time.

To apply this header to your Node.js app, you should include the following:

```js
function requestHandler(req, res) {
	res.setHeader( 'X-XSS-Protection', '1; mode=block' );
}
```

Note the two *directives* in this header:  `1` is simply acts as a boolean 1 or 0 value to reflect on or off.  `mode=block` will stop the entire page loading, instead of simply sanitising the page as it would if you excluded this directive.

If you're a security-freak like myself, and a user of the Chromium browser, you could even go one-step further than this and set the directives like so:

	X-XSS-Protection: 1; report=<reporting-uri>

Now, if the browser detects an XSS attack, the page will be sanitized, and report the violation.  Note that this uses the functionality of the CSP `report-uri` directive to send a report that I will talk about in the Content Security Policy section below.


## Defend against Clickjacking

Clickjacking occurs when a malicious agent injects objects / iFrames into your DApp, made to look identical, that actually sends the User to a malicious site when clicked.  Another common, and possibly more scary example is that malicious agents insert something like a payment form into your DApp, that looks identical to your DApp, but steals payment details.

Now, whilst this *could* be a very dangerous issue, it's very easy to mitigate, with almost no impact on your Web App.  Servers offer Browsers a Header Protocol named `X-Frame-Options`.  This protocol allows us to specify domains to accept iFrames from.  It also allows us to state which sites our Web App can be embedded on.  With this protocol, we get three fairly self-explanitory options/directives:  `DENY`, `ALLOW-FROM`, and `SAMEORIGIN`.

If we choose `DENY`, we can block all framing.  If we use `ALLOW-FROM`, we can supply a list of domains to allow framing within.  I use the `SAMEORIGIN` directive, as this means framing can only be done within the current domain.  This can be utilised with the following:

```js
function requestHandler(req, res) {
	res.setHeader( 'X-Frame-Options', 'SAMEORIGIN' );
}
```


## Content Security Policy (CSP)

CSP is another major topic when it comes to Server-Browser security for Web Apps.  At a high-level; Content Security Policies tell the browser what content is authorised to execute on a Web App, and what will block.  Primarily, this can be used to prevent XSS, in which an attacker could place a `<script>` tag on your Web App.  The Content-Security-Policy is a Server-Browser header that we can set to ensure our Server tells the Browser exactly which media, scripts, and their origins, we will allow to be executed on our Web app.

The whitelisting of resource loading and execution URIs provides a good level of security, that will in most parts, defend against most attacks.

To include a Content Security Policy that allows only internal and *Google Analytics*, in an Express.js server, you could do the following:

```js
var express = require('express');
var app = express();


app.use(function(req, res, next) {
    res.setHeader("Content-Security-Policy", "script-src 'self' https://analytics.google.com");
    return next();
});

app.use(express.static(__dirname + '/'));

app.listen(process.env.PORT || 3000);
```

However, if we do not wish to allow *any* external sites to execute scripts on our Web App, we could simply include the following:

```js
function requestHandler(req, res) {
	res.setHeader( 'Content-Security-Policy', "script-src 'self'" );
}
```

Note the `script-src` directive here, that we have set to `self`, therefore only allowing scripts from within our own domain.  Of course, CSP is not without its own problems.  Firstly, it would be very easy for us to forget about some of the media we have in our Web App and to simply exclude them accidentally.  Now that the web is so *rich* in media, this would be reasonably easy to do.  Secondly, many of us use third-party plugins on our Web App.  Again, unless we have a full blueprint of these, we could very easily block them.

So, once activated, this Server Header *could* potentially be very detrimental to us.  However, there are two great ways of testing this.  You can set a strict policy, and use the built in directives; `report-only` and `report-uri` to test them.  The `report-uri` directive tells the Browser to send a JSON report of all of the blocked scripts to a URi that we specify.  The `report-only` directive does the same, but will ***not*** block the scripts on the site.  This is very useful for testing, before we put this Header into production.

There's a great write-up on the reporting, [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only).

Content Security Policies are both excellent and very powerful, but must be used cautiously.  Much the same as HSTS mentioned above, we need to ensure we are aware of the situation before activating.  If you are loading in external images, scripts etc. you need to understand that unless you include these in the policy, they ***will*** be blocked.


## CSRF

Cross Site Request Forgery (CSRF) has been at the forefront of Web App Security for longer than any of us care to remember.  The idea behind it is that a malicious agent sends a (forged) request from one app to another whilst the User is signed in and authorised.  This would therefore allow the request to enter and alter restricted actions on the requested App, with the requested app believing entirely that the actions were coming from the logged in User.  A better way for me to describe this is to show you:

Imagine if you will, I am security-abusing miscreant, and I happen to know that Twitter has no CSRF protection.  (They do, this is all hypothetical.)  I'm also aware that most people who visit *my* Web App, probably leave their Twitter logged in, and therefore have a Cookie stored in their browser, to allow them fast access to Twitter the next time they want to post something.

On my Web App, I could embed a script such as the following:

~~~html
<form action="https://twitter.com/tweet" method="POST" id="sendTweet">
<input type="hidden" name="tweet" value="Hey!  Check out my awesome spam site - spam.com">
~~~

When your browser loads my Web App, this form will be loaded (entirely invisibly) too.  I would then also have embedded a small piece of JS to POST the form, without you ever knowing:

~~~js
document.getElementById("sendTweet").submit();
~~~

In doing this, I've just sent a Tweet on your account, without ever having to know your Username or Password.  The Cookie you had stored in your Browser allowed my app to send a *forged request*, pretending to be you - and if Twitter had no CSRF mitigation, it would have worked too!

For years, we have been trying to solve CSRF requests by checking HTTP headers such as the `Origin` and `Referer`.  Whilst these have offered fairly robust protection for a few years, there is now a simple directive that once applied; will entirely mitigate CSRF attacks.

Enter, the ***SameSite*** Cookie directive.  SameSite is relatively new, and only been around for the past year, in which it has gained some publicity, but is still widely unknown.  In essence, the SameSite directive, once applied, will tell the Browser to **never** send that cookie when a request from an external (Cross Site) url is made.  We can apply this directive by altering our Cookies as such:

	Set-Cookie: sess=sessionid123; path=/; SameSite

It really is that easy.  I wouldn't recommend removing your existing CSRF protection just yet, but I would definitely recommend including this directive on your Web App.


## Cookies

As we know, cookies are an important feature of our Web Applications, carrying data mainly referring to our User Sessions.  While simply implementing the aforementioned directives is sufficient in securing your cookies, and preventing attacks, we can actually take cookie security a step further.

*Cookie Prefixing* is a relatively under-used technique that we can utilise to ensure a cookie *is* secure:

***The `__Secure` prefix*** - If a cookie's name begins with "__Secure", the cookie MUST be:

- Set with a "*Secure*" attribute
- Set from a URI whose scheme is considered secure by the user agent.

The following cookie would be rejected when set from any origin, as the "Secure" flag is not set:

	Set-Cookie: __Secure-sess=12345; Domain=myapp.com

While the following would be accepted if set from a secure origin e.g. `https://` and rejected otherwise:

	Set-Cookie: __Secure-sess=12345; Secure; Domain=myapp.com

Alongside the `__Secure` prefix, we also have the `__Host` prefix:

***The `__Host` prefix*** - If a cookie's name begins with "__Host", the cookie MUST be:

- Set with a "Secure" attribute
- Set from a URI whose "scheme" is considered "secure" by the user agent.
- Sent only to the host which set the cookie.  That is, a cookie named "__Host-cookie1" set from "https://example.com" *MUST NOT* contain a "Domain" attribute (and will therefore be sent only to "example.com", and not to "subdomain.example.com").
- Sent to every request for a host.  That is, a cookie named "__Host-cookie1" MUST contain a "Path" attribute with a value of "/".

The following cookies would always be rejected:

	Set-Cookie: __Host-sess=12345
	Set-Cookie: __Host-sess=12345; Secure
	Set-Cookie: __Host-sess=12345; Domain=example.com
	Set-Cookie: __Host-sess=12345; Domain=example.com; Path=/
	Set-Cookie: __Host-sess=12345; Secure; Domain=example.com; Path=/

While the following would be accepted if set from a secure origin e.g. `https://`, and rejected otherwise:

	Set-Cookie: __Host-sess=12345; Secure; Path=/

By setting these prefixes, any compliant browser will be made to enforce them.

Now, if we include the tips from my first article, and the tips above, we can make the most secure Cookie possible:

	Set-Cookie: __Host-sess=id123; path=/; Secure; HttpOnly; SameSite

In this most-secure-cookie, we're utilising the `__Host` prefix which means the `Secure` attribute has to be set, and it must be served from a secure host.  There is no `Domain` attribute set and the `Path` is /.  We've set `HttpOnly` for XSS protection, and SameSite is enabled too to prevent CSRF.  Of course, this won't be the best or most practical solution for a lot of people, but it *is* the most in-theory secure Cookie we could set from our Web App.


## Take a DApp Blueprint

***Note** - In my opinion, this is one of the most important security steps one can take.*

Do you know the ins-and-outs of each library your Developers use?  Probably not - it's near impossible to keep track nowadays, but this is to *great* detriment.  Are you also aware of which libraries and tools have been given write access to your production servers and databases - and how isolated they are?

The issue here is that using so much *automation* in modern development, we grant access to a huge amount of tools/libraries without *really* knowing exactly what they're doing.  We take it for granted that each of these libraries is entirely safe and without their security vulnerabilities - or worse - performing malicious activities themselves.

We all want the most streamlined Dev cycle possible.  We all use automation tools that trigger a whole bunch of processes, doing things that barely any of us are aware of.  The propensity of some Devs to throw `sudo` commands at package managers if a command fails is also truly terrifying.

So how do we get around this?  ***Take a Tech Blueprint!***  This needn't be a complex process, it's as simple as knowing what each piece of Software is doing on your servers, and what authority they've been granted.  Take a note of any new tools / packages before you grant them permissions, and do a little research.  Some simple Googling of key phrases i.e. `*package* security vulnerabilities` will usually bring up more results than you'd expect.  It's also worth checking out the *Issues* tab on the package's GitHub page.  Vulnerabilities are often discussed there and you'll be able to act accordingly.  This applies to the top-level Package Managers too.

Package managers are used by almost ALL of us.  If you really want to scare yourself, go ahead and search `*package manager* security vulnerability` and take a look at all of the results!  Again, knowing what we are installing and granting permissions to, and especially keeping a note of this, could just save our Bacon.  Take a look at [https://medium.com/friendship-dot-js/i-peeked-into-my-node-modules-directory-and-you-wont-believe-what-happened-next-b89f63d21558](this article for a relevant example!)

**Handy tip:**  if you want to know which hooks an npm package runs, before you install it, run the command:

```bash
  $ npm show $module scripts
```

## Security for DApp Users

![Dapp security](https://cdn-media-1.freecodecamp.org/images/1*sd62aH6GGS1RoCR9t4QNyQ.png)
[Image Source](https://www.freecodecamp.org/news/how-to-design-a-secure-backend-for-your-decentralized-application-9541b5d8bddb/)

With more and more DApps being created including web-based exchanges, crypto-based games etc.  The opportunities for bad actors increase with each new DApp released.  Say, for instance, someone released an interactive game built around Web3, and directly interacting with user's wallets.  On registration for the game, wallets are created, and they collected sensitive data, including user's private keys being stored in local storage (super insecure).

The DApp developer, however, didn't realise that a bad actor has been injecting a remote script during registration that evaluates and sends all of the player's private keys to the bad actor's server.

 - **Protect wallets and private keys:** If user’s wallets are compromised, this is game over. Extreme care needs to be taken when handling this sensitive information.
 - **Protect user information:** Users do not want their personal data being exposed to the world. Ensure that user data remains private.
 - **Use *MetaMask* or similar** to ensure security of wallets and user keys.
 - **Evaluate wisely what needs to be stored in the blockchain or in your servers.** Only include data that is absolutely necessary for you smart contracts to function within the contracts themselves.

There is an excellent write-up on DApp security standards you [can check out here.](https://github.com/Dexaran/DAPP-security-standards/blob/master/README.md)


## Conclusion
Without a doubt, the most effective method for maintaining the security of your DApps  is keeping up-to-date with any security protocols on an ongoing basis.  Vulnerabilities are an extremely fickle and dynamic topic, in that they change / pop up so regularly.

By following the tips in this article, keeping up-to-date with any security announcements, and having an in-depth overview of your systems, you can rest assured that you are well on your way to having a jolly well secured web app.  As stressed in this article, security considerations are not only found on the Back end of our apps, but on the Front end too.  Ensuring that we approach both means we can be confident about the safety of our users (which should be our number one priority).  The best tools in web security are common sense and vigilance.

So, from enforcing HTTPS with Strict Transport Security, to securing our DApp frontend with a Content Security Policy; we’ve covered the main topics, in my opinion to ensuring Front end to Back end security for our web & decentralised web applications. These topics are all techniques I utilise myself and would advocate for use in your apps on an ongoing basis.

[ **_- @rbin_**](https://twitter.com/rbin)


