---
---

$ ->

	# init map
	$mapElem = $('#home-map')

	if (typeof($mapElem) != 'undefined' && $mapElem != null)

		map = L.map($mapElem.attr('id'), {scrollWheelZoom: false}).setView([27.988945, -82.507324], 10);
		L.control.locate().addTo map
		L.esri.basemapLayer('Streets').addTo map

		map.on 'click', ->
			if map.scrollWheelZoom.enabled()
				map.scrollWheelZoom.disable()
			else
				map.scrollWheelZoom.enable()
			return

		# layer toggle container
		overlay_toggles_elem = document.getElementById 'map-overlay-toggles'

		# layers
		layers = [
			{
				name: 'Hospitals'
				visible: true
				url: 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/County_Webmap/MapServer/0'
				iconClass: 'hc-map-icon-hospital'
			}
			{
				name: 'Senior Centers'
				visible: false
				url: 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/County_Webmap/MapServer/1'
				iconClass: 'hc-map-icon-senior-center'
			}
			{
				name: 'Fire Stations'
				visible: false
				url: 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/County_Webmap/MapServer/2'
				iconClass: 'hc-map-icon-fire-station'
			}
		]

		# default popup template
		defaultPopupTemplate = (attr) ->
			out = """
			<h4 class="popover-title">{NAME}</h4>
			<div class="popover-content">
				<p>{ADDRESS}</p>
			"""
			if attr
				out += """
				<p>
					<a href="#" class="btn btn-secondary btn-sm btn-block">Learn More</a>
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

		# iterate layers
		$.each layers, (index, layer) ->
			new_layer = L.esri.featureLayer
				url: layer.url
				pointToLayer: (esriFeature, latlng) ->
					L.marker latlng, icon: L.divIcon className: 'hc-map-icon '+layer.iconClass

			new_layer.bindPopup (e) ->
				properties = e.feature.properties
				L.Util.template defaultPopupTemplate(true), properties

			addFeatureLayer new_layer, layer
			return
