---
---

$ ->

	# map initializer
	$.fn.initHcMap = ->
		map = L.map $(this).attr('id'), {scrollWheelZoom: false}
		map.setView [27.988945, -82.507324], 10
		L.control.locate().addTo map
		L.esri.basemapLayer('Topographic').addTo map
		toggleScrollWheel map
		return map

	# map service with correct WEB_* fields
	map_service = 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/'

	# home page map
	$('#home-map').each ->
		map = $(this).initHcMap()

		# layers
		layers = [
			{
				name: 'County Public Offices'
				visible: true
				urls: [
					map_service + '2' # Community Resource Centers
					map_service + '3' # Consumer Protection Offices
					map_service + '12' # Customer Service Center for Public Utilities
					map_service + '10' # Pet Resource Center
					map_service + '4' # County Center
					map_service + '16' # Veterans Services Offices
				]
				iconClass: 'hc-map-icon-public-office'
			}
			{
				name: 'Community Collection Centers'
				visible: false
				urls: [
					map_service + '1' # Community Collection Centers
				]
				iconClass: 'hc-map-icon-collection-center'
			}
			{
				name: 'Senior Centers'
				visible: false
				urls: [
					map_service + '13' # Community Collection Centers
				]
				iconClass: 'hc-map-icon-senior-center'
			}
			{
				name: 'Parks and Recreation Sites'
				visible: false
				urls: [
					map_service + '9' # Parks
				]
				iconClass: 'hc-map-icon-park'
			}
			{
				name: 'Constitutional Offices'
				visible: false
				urls: [
					map_service + '15' # Tax Collector Locations
					map_service + '0' # Clerk of Court Locations
					map_service + '14' # Supervisor of Elections Locations
					map_service + '6' # Hillsborough County Sheriff Office Locations
					map_service + '11' # Property Appraiser Locations
				]
				iconClass: 'hc-map-icon-const-office'
			}
			{
				name: 'Fire Stations'
				visible: false
				urls: [
					map_service + '5' # Fire Stations
				]
				iconClass: 'hc-map-icon-fire-station'
			}
			{
				name: 'Libraries'
				visible: false
				urls: [
					map_service + '8' # Libraries
				]
				iconClass: 'hc-map-icon-library'
			}
		]

		# layer toggle container
		overlay_toggles_elem = document.getElementById 'map-overlay-toggles'

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
			layer_group = L.layerGroup();

			$.each layer.urls, (l_index, url) ->
				new_layer = L.esri.featureLayer
					url: url
					pointToLayer: (esriFeature, latlng) ->
						L.marker latlng, icon: L.divIcon className: 'hc-map-icon '+layer.iconClass

				new_layer.bindPopup (e) ->
					properties = e.feature.properties
					L.Util.template defaultPopupTemplate(properties), properties

				layer_group.addLayer new_layer
				return

			addFeatureLayer layer_group, layer
			return

		return # end each

	# single layer maps
	$('.hc-map').each ->
		map = $(this).initHcMap()

		unless $(this).data('layer') == undefined || $(this).data('layer') == ''
			layer = L.esri.featureLayer
				# url: $(this).data('layer')
				url: map_service + $(this).data('layer')
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

# shared functions

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

# scroll wheel toggle
toggleScrollWheel = (map) ->
	map.on 'click', ->
		if map.scrollWheelZoom.enabled()
			map.scrollWheelZoom.disable()
		else
			map.scrollWheelZoom.enable()
		return
	return
