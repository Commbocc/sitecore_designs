---
---

$ ->
	$('.hc-map-v2').each ->
		map = new HcMap($(this), "{{ '/maps/templates/' | prepend: site.baseurl }}")
		return
