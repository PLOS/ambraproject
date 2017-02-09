---
layout: default
title: User Documentation

---

<div class="column-container">

<div class="column-one">

<p>Ambra has been under continuous development as the engine behind the <a href="http://journals.plos.org/">PLOS
journals</a> since 2009. For its first two major versions, Ambra was a
monolithic Struts web application, which has been offered as open source since
its beginning.</p>

<p>In 2012, PLOS began a project to re-architect Ambra as a service-oriented,
multi-component application. PLOS has actively been using, testing, and
improving these new components in its journal platform since 2013. PLOS finally
replaced the legacy Ambra webapp in its entirety in early 2016 and republished
the code as open source in early 2017.</p>

<p>Because this re-architected version of Ambra has been in use only by PLOS staff
for the years prior to its release, you might experience some challenges in
setting it up. The documentation on this website is intended to provide
everything you need to get started, but you may encounter omissions, bugs, or
other obstacles. If you do, we encourage you to <a href="mailto:dev@ambraproject.org">contact us</a>. If the
project's current state is rough around the edges, it is because it is
relatively new to third-party use and needs feedback from prospective users.
Your response will drive future improvement of the open-source side of the
project.</p>

<p>We hope that what the current Ambra application may lack in user-friendliness
and polish, it will make up for in robustness, flexibility, and an unparalleled
focus on the needs of <a href="https://www.plos.org/open-access/">Open Access</a> scholarly publishing. Thank you for
your interest in this software. We have put a lot into it, and we hope you can
get something out of it that will promote the causes of open science and open
software.</p>
</div>
<div class="doclist column-two">
<ul>
    {% assign navigation_pages = site.html_pages | sort: 'navigation_weight' %}
    {% for p in navigation_pages %}
      {% if p.navigation_weight %}
       <li>
        <h3>
          <a href="{{ p.url | relative_url }}" >
            {{ p.title }}
          </a>
          </h3>
        </li>
      {% endif %}
    {% endfor %}
    </ul>
</div>
</div>
