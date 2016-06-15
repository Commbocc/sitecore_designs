---
---

# default popup template
defaultPopupTemplate = (properties) ->
	directions_str = [properties.WEB_ADDRESS, properties.WEB_CITY, 'FL', properties.WEB_ZIP].join('+').replace(/[^0-9a-z]/gi, '+').replace(' ', '+')
	out = """
	<h4 class="popover-title">{WEB_NAME}</h4>
	<div class="popover-content">
		<p>
			{WEB_ADDRESS}<br>
			{WEB_CITY}, FL {WEB_ZIP}<br>
			<a href="https://www.google.com/maps/dir//"""+directions_str+"""" target="_blank" class="small pull-right">Directions</a>
		</p>
	"""
	if properties.WEB_URL != null && properties.WEB_URL != ''
		out += """
		<p>
			<a href="{WEB_URL}" class="btn btn-secondary btn-sm btn-block">Learn More</a>
		</p>
		"""
	out += "</div>"
	return out

$ ->

	# init map
	$mapElem = $('.hc-map')

	$mapElem.each ->
		map = L.map $(this).attr('id'), {scrollWheelZoom: false}
		map.setView [27.988945, -82.507324], 10
		L.control.locate().addTo map
		L.esri.basemapLayer('Topographic').addTo map

		map.on 'click', ->
			if map.scrollWheelZoom.enabled()
				map.scrollWheelZoom.disable()
			else
				map.scrollWheelZoom.enable()
			return

		if $(this).data('layer')
			layer = L.esri.featureLayer
				url: $(this).data('layer')
				# where: "WEB_NAME LIKE '%main street%'"
				pointToLayer: (esriFeature, latlng) ->
					L.marker latlng, icon: L.divIcon className: 'hc-map-icon'

			layer.bindPopup (e) ->
				properties = e.feature.properties
				L.Util.template defaultPopupTemplate(properties), properties

			layer.on 'createfeature', ->
				bounds = []
				$.each $(this)[0]._layers, (index, marker) ->
					bounds.push marker._latlng
					return
				map.fitBounds bounds
				return

			map.addLayer layer

		return
