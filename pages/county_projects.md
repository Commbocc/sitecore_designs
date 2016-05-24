---
layout: page
permalink: /county_projects/
---

## Select a project below

### Transportation

{% for project in site.county_projects %}
{% if project.type == 'transportation' %}
* [{{ project.title }}]({{ project.url | prepend: site.baseurl }})
{% endif %}
{% endfor %}

### Community/Building

{% for project in site.county_projects %}
{% if project.type != 'transportation' %}
* [{{ project.title }}]({{ project.url | prepend: site.baseurl }})
{% endif %}
{% endfor %}
