---
layout: default
title: Developer Overview
navigation_weight: 5

---

This is an introduction to some of the key concepts and abstractions used
within the source code of the Ambra stack, intended for software developers who
want to contribute or debug it. (It is not necessary to read this document if
you only want to use or administer the system.)

The Ambra stack consists of several service-oriented components. You should
follow the [Quickstart Guide][quickstart], both to set up your development
system and to give yourself some rough familiarity with what the components are
and what each one does.

  [quickstart]: Quickstart-Guide.html

Wombat
======

"Wombat" is the stack's display component. It is a [Spring Web MVC][swmvc]
application. It scoops up a small set of configuration data on start-up from
the `wombat.yaml` file, which points to the system's theme directory. The
theme's provide the bulk of the system's configuration values, as well as any
custom front-end code and static content that the user plugs in.

  [swmvc]: https://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html

Sites and Themes
----------------

A key abstraction in Wombat is the **site**. One instance of the Ambra stack
can serve multiple logical sites, potentially representing different journals
or publications. Each site can have a distinct set of front-end files, and can
even be served on different domain names if the network infrastructure in front
of them is set up correctly. But they have the advantage of being able to link
to each other, overlapping in such areas as "related article" links and search
results. Another application of the "site" abstraction is to have two front-end
designs for the same publication, such as one desktop-styled site and one
mobile-friendly site.

Each site is mapped to a single **theme**, which is a directory of files that
provide the configuration and front-end code that the site will use. Themes
reuse each other's code and content through an inheritance mechanism. An
overview of theme inheritance is provided in the [Quickstart Guide][quickstart]
and on the "[Working with PLOS's Themes][plosthemes]" page.

  [plosthemes]: themes-documentation.html

In our Java code, the [`Site`][Site] and [`Theme`][Theme] classes represent
these two abstractions.

  [Site]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/site/Site.java
  [Theme]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/theme/Theme.java

Note the relationship between a **site** and a **journal**. A journal may be
represented by more than one site, as in the "desktop and mobile" example
above. To resolve a journal key into a link to another site, it is necessary to
use the `Theme.resolveForeignJournalKey` Java method from the originating
site's theme. For example, if we are in the `MobilePlosMedicine` site and we
have a key identifying the journal _PLOS Biology_, we must use the `Site`
object for `MobilePlosMedicine` to resolve to the `MobilePlosBiology` site.
Otherwise, there would be no way to tell that we don't want
`DesktopPlosBiology` instead.

Request mapping
---------------

Wombat customizes its sites' URLs by tacking some fairly heavy-duty extensions
on top of Spring's default request handlers. Most of the gory framework details
are contained in the [`SiteHandlerMapping`][SiteHandlerMapping], [`SiteRequestCondition`][SiteRequestCondition] and
[`RequestMappingContext`][RequestMappingContext] classes. In short,
`RequestMappingContext` picks up data from the `@RequestMapping` annotations
that appear on all the controller methods and `SiteHandlerMapping` exposes our
custom logic to Spring.

  [SiteHandlerMapping]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/site/SiteHandlerMapping.java
  [SiteRequestCondition]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/site/SiteRequestCondition.java
  [RequestMappingContext]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/site/RequestMappingContext.java

The `@RequestMapping` annotations are a common sight in the controllers of any
normal Spring Web MVC application, but, because of the extensions described
above, we use them in a slightly special way. Each one *must* supply a `name`
attribute (which ordinarily is optional), or else it will be impossible to link
to it as described in the "Linking" section below.

Furthermore, the `SiteRequestCondition` class tampers with the path pattern in
the `@RequestMapping(value="...")` attribute before it is passed to Spring. The
`mappings.yaml` config file allows the user to override these values on a
per-site basis at runtime. See the documentation on [the root `mappings.yaml`
file][mappings] for details. Even if the user doesn't override the path, many
sites will need to add a token to the beginning of the pattern as described in
the "Request handling" section below, which `SiteRequestCondition` does
automatically.

  [mappings]: https://github.com/PLOS/wombat/blob/master/src/main/webapp/WEB-INF/themes/root/config/mappings.yaml

One final detail is "siteless" request handlers, which are represented in the
`RequestMappingContext` class. We need a few global handlers to be mapped to
URLs that belong to no site. Such handlers are marked with the `@Siteless`
annotation. These handlers get a simple mapping that ignores all the details
from the "Request handling" section.

Request handling
----------------

The actual logic of mapping an HTTP request onto a site is in the
[`SiteResolver`][SiteResolver] class, which is mercifully less gory than the
classes in the previous section. Each `Site` object comes equipped with a
[`SiteRequestScheme`][SiteRequestScheme] object, and the `SiteResolver` doesn't
do much beyond applying each scheme to the request, looking for a hit. The
schemes are composed of the various [predicate][predicate] objects in the
[`org.ambraproject.wombat.config.site.url`][urlpackage] package.

  [SiteResolver]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/site/SiteResolver.java
  [SiteRequestScheme]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/site/url/SiteRequestScheme.java
  [predicate]: https://en.wikipedia.org/wiki/Predicate_(mathematical_logic)
  [urlpackage]: https://github.com/PLOS/wombat/tree/master/src/main/java/org/ambraproject/wombat/config/site/url

The `SiteRequestScheme` objects get populated from the `sites.yaml` file picked
up from Wombat's theme directory. For example, one entry in the configuration
for PLOS's production site mappings reads as follows:

      - key:   DesktopPlosOne
        theme: DesktopPlosOne
        resolve:
            host: journals.plos.org
            path: plosone
            headers:
              - name:  X-Wombat-Serve
                value: desktop

Each of the three entries under `resolve` corresponds to a
`SiteRequestPredicate` instance that gets built. Let's unpack them
individually:

  * `host` is a custom hostname. If the Apache server in front of our Tomcat
    container did the necessary magic to route the request from the
    `journals.plos.org` hostname to our webapp, then the request is eligible to hit
    this site.
  * `path` is a token that appears at the beginning of the servlet path, in this
    case distinguishing URLs like `http://journals.plos.org/plosone/` from
    `http://journals.plos.org/plosbiology/`. Note that it begins only after the URL
    of the servlet context, which in this case is the domain root because the
    webapp happens to be deployed to Tomcat as `ROOT.war`. If it were `wombat.war`,
    then the URL might look like `http://journals.plos.org/wombat/plosone/`
    instead.
  * `headers` is a list of additional HTTP headers to look for. In PLOS's case, the
    task of identifying mobile clients is offloaded to the Apache server, which we
    rely on to set a custom `X-Wombat-Serve` header. If no such header is set,
    Wombat will resolve the request to neither the desktop nor the mobile site,
    resulting in a siteless 404 error. (This is a common failure mode for dev
    instances that have accidentally been set up with the production site
    resolution config, but with no server setting the `X-Wombat-Serve` header in
    front of it.)

Linking
-------

Because of the complexity around resolving URLs, there is necessarily some
complexity around building links to those URLs as well. Wombat uses the
[`Link`][Link] class to do this. Although the private code in the `Link` class
is quite hairy, it is relatively simple to call from the outside.

  [Link]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/site/url/Link.java

To build a link from within Java code, call one of the static methods that
returns a `Link.Factory` object: `toLocalSite`, `toForeignSite`, or
`toAbsoluteAddress`. Then call a `toPattern` method and supply the necessary
values and query parameters to complete the URL. Details appear in the `Link`
class's Javadoc.

It should be possible to chain these method calls so that you don't ordinarily
have to store any variables of the `Factory` or `PatternBuilder` types. For
example:

    Link link = Link.toForeignSite(localSite, targetJournalKey, siteSet)
        .toPattern(requestMappingContextDictionary, "article")
        .addQueryParameter("id", doi)
        .build();
    String url = link.get(request);

*Always* prefer the `toPattern` method over `toPath`. The `toPattern` method
points at a handler using the `name` attribute from its `@RequestMapping`
annotation, and will dynamically generate a URL for its configured URL pattern.
If you use `toPath`, the link may break if the site mappings are changed in
`sites.yaml` or if the handler mapping is changed in `mappings.yaml`.

However, you mostly will not be building links from Java code, but from
FreeMarker. The [`SiteLinkDirective`][SiteLinkDirective] lets you invoke the
same link-building code from a FreeMarker template. As with the `Link` class,
the directive may be used with a handler name or with a raw path; always prefer
the handler name. For example:

    <@siteLink handlerName="article" queryParameters={"id": article.doi} />

Sometimes you will want a URL to appear within FreeMarker code in a place where
it would be unreadable to shove a bulky directive invocation like the one
above. In such cases, it is good style to bind the result to a "loop var" as
follows:

    <@siteLink handlerName="article" queryParameters={"id":article.doi} ; href>
      <a href="${href}">${article.title}</a>
    </@siteLink>

  [SiteLinkDirective]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/freemarker/SiteLinkDirective.java

Calling services
----------------

Wombat has no access to persistent data on its own. It gets everything by
making HTTP calls to remote services. The tools to make these calls live in the
[`org.ambraproject.wombat.service.remote`][remote] package.

  [remote]: https://github.com/PLOS/wombat/tree/master/src/main/java/org/ambraproject/wombat/service/remote

For each remote component, there is a interface that extends the
[`RestfulJsonApi`][RestfulJsonApi] interface, which Wombat uses to make
requests to that component. The class names avoid using component nicknames
like "Rhino" in favor of descriptive terms, as follows:

  [RestfulJsonApi]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/service/remote/RestfulJsonApi.java

| Target component | Wombat's service interface |
|------------------|----------------------------|
| Rhino            | [`ArticleApi`](https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/service/remote/ArticleApi.java) |
| Content Repo     | [`ContentApi`](https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/service/remote/ContentApi.java) |
| NED              | [`UserApi`](https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/service/remote/UserApi.java) |

The main way to make requests to the `RestfulJsonApi` interface is with the
`ApiAddress` class, which encapsulates a query to the API and produces a URL.
It uses a builder pattern to construct an `ApiAddress` instance tersely, and
its `embedDoi` method will apply Rhino's DOI-escaping scheme. For example:

    ApiAddress.builder("articles").embedDoi(articleId.getDoi()).addToken("revisions").build()

Each `RestfulJsonApi` object wraps around a [`RemoteService`][RemoteService]
object, which does the actual work of making the HTTP request. The
`RemoteService` classes encapsulate performance concerns such as HTTP
connection pooling and caching. These details are set up in
[`RootConfiguration`][RootConfiguration].

  [RemoteService]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/service/remote/RemoteService.java
  [RootConfiguration]: https://github.com/PLOS/wombat/blob/master/src/main/java/org/ambraproject/wombat/config/RootConfiguration.java

Rhino
=====

"Rhino" is a service component that provides a loosely RESTful interface to the
stored corpus of articles belonging to the system's journals, and all data
associated with those articles such as user comments. Although it does not
serve any user-facing HTML content, it is also a Spring Web MVC application. It
uses this framework mostly to serve metadata describing the state of the corpus
in JSON format, but it also serves some forms of raw data.

Rhino's back end is a MySQL database that it accesses via Hibernate. It gets
its MySQL connector from a typical `context.xml` file, and additionally picks
up some bespoke configuration from `rhino.yaml`.

Service responses
-----------------

Rhino uses the [`ServiceResponse`][ServiceResponse] and
[`CacheableResponse`][CacheableResponse] classes to encapsulate raw response
data that is intended to be returned to the client as JSON data. Many service
classes have `ServiceResponse` as the return type to their methods. (This is
perhaps not the *best* separation of layers. It may help to think of the
response class as being a bridge between the service layer and controller
layer.)

  [ServiceResponse]: https://github.com/PLOS/rhino/blob/master/src/main/java/org/ambraproject/rhino/rest/response/ServiceResponse.java
  [CacheableResponse]: https://github.com/PLOS/rhino/blob/master/src/main/java/org/ambraproject/rhino/rest/response/CacheableResponse.java

A service method calls a static factory method and returns a `ServiceResponse`
object. In cases where the service has access to a "last modified" timestamp of
the entity in question, instead construct and return a `CacheableResponse`. The
controller that receives the `CacheableResponse` supplies to it an "if modified
since" timestamp and unpacks it into a `ServiceResponse` object, which then
produces the response as normal (and will provide an empty response with a "not
modified" status if appropriate).

Note the semantics of the service methods that sometimes return a
`ServiceResponse` and sometimes don't. For methods that look up a persistent
entity, Rhino has a (mostly) consistent naming convention that depends on how
to handle missing entities. Please follow this convention when adding new
methods.

| Return type          | Verb  | Meaning |
|----------------------|-------|---------|
| `Optional<T>`        | get   | Fetch something that may or may not exist. Check after returning. |
| `T`                  | read  | Fetch something that must exist. Throw an exception if it doesn't. |
| `ServiceResponse<T>` | serve | Fetch something the client expects to exist. Produce a 404 response if it doesn't. |

Note that *none* of these three method types *ever* return `null`.
