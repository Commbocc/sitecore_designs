---
---


$ ->

	getUrlParameter = (sParam) ->
		sPageURL = decodeURIComponent(window.location.search.substring(1))
		sURLVariables = sPageURL.split('&')
		sParameterName = undefined
		i = undefined
		i = 0
		while i < sURLVariables.length
			sParameterName = sURLVariables[i].split('=')
			if sParameterName[0] == sParam
				return if sParameterName[1] == undefined then true else sParameterName[1]
			i++
		return

	layer_ids = getUrlParameter('layer_ids').split(',')

	console.log layer_ids

	# init map
	$mapElem = $('#hc-query-map')

	if (typeof($mapElem) != 'undefined' && $mapElem != null)

		map = L.map($mapElem.attr('id'), {scrollWheelZoom: false}).setView([27.988945, -82.507324], 10);
		L.esri.basemapLayer('Streets').addTo map

		map.on 'click', ->
			if map.scrollWheelZoom.enabled()
				map.scrollWheelZoom.disable()
			else
				map.scrollWheelZoom.enable()
			return

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

			# add Layer function
			addFeatureLayer = (layer, obj) ->
				toggle = document.createElement('a')
				toggle.href = '#'
				toggle.className = 'map-overlay-toggle'
				toggle.innerHTML = '<div class="hc-map-icon '+obj.iconClass+'"></div> ' + obj.name
				if obj.visible
					layer.addTo map
					toggle.className = 'map-overlay-toggle active'
				toggle.onclick = (e) ->
					e.preventDefault()
					e.stopPropagation()
					if map.hasLayer(layer)
						map.removeLayer layer
						@className = 'map-overlay-toggle'
					else
						map.addLayer layer
						@className = 'map-overlay-toggle active'
					return
				overlay_toggles_elem.appendChild toggle
				return
