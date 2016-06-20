---
---

$ ->

	# map service with correct WEB_* fields
	map_service = 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/'

	# map initializer
	$.fn.initHcMap = ->
		map = L.map $(this).attr('id'), {scrollWheelZoom: false}
		map.setView [0,0], 10
		toggleScrollWheel map
		L.esri.basemapLayer('Topographic').addTo map
		L.control.locate().addTo map
		# Hillsborough County Boundaries
		northWest = L.latLng(28.173379, -82.823669)
		southEast = L.latLng(27.57055, -82.054012)
		map.fitBounds L.latLngBounds(northWest, southEast)
		return map

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

		# close map overlays on any other click
		$(document).click (event) ->
			# clickover = $(event.target)
			_opened = $('#map-overlays').hasClass('in')
			if _opened == true
				$('#map-overlays').removeClass('in')
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

			addLayerToMapAndMapOverlaysPanel map, layer_group, layer
			return

		return # end #home-map each

	# single layer maps
	$('.hc-map-layer').each ->
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

	# geo lookup maps
	$('.hc-map-geo').each ->
		map = $(this).initHcMap()
		setGeoMarker $(this).data('name'), $(this).data('address'), map
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

# geo popup template
geoPopupTemplate = (title, address) ->
	directions_str = [address].join('+').replace(/[^0-9a-z]/gi, '+').replace(' ', '+')
	out = """
	<h4 class="popover-title">"""+title+"""</h4>
	<div class="popover-content">
		<p>
			"""+address+"""<br>
			<a href="https://www.google.com/maps/dir//"""+directions_str+"""" target="_blank" class="small pull-right">Directions</a>
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

# function that adds a layer to map and map overlays panel
addLayerToMapAndMapOverlaysPanel = (map, layer, obj) ->
	$toggle = $('<a href="#" class="map-overlay-toggle"></a>')
	$toggle.html '<span class="hc-map-icon '+obj.iconClass+'"></span> ' + obj.name

	if obj.visible
		layer.addTo map
		$toggle.appendTo('#map-overlay-toggles').addClass('active')
	else
		$toggle.appendTo('#map-overlay-toggles')

	$toggle.on 'click', (e) ->
		e.preventDefault()
		e.stopPropagation()
		if map.hasLayer(layer)
			map.removeLayer layer
			$(this).removeClass 'active'
		else
			map.addLayer layer
			$(this).addClass 'active'
		return

	return

# add esri geosearch marker to map
setGeoMarker = (title, searchStr, map) ->
	client = new L.GeoSearch.Provider.Esri()
	json_url = client.GetServiceUrl searchStr
	$.get json_url, (data) ->
		coordinates = client.ParseJSON(data)[0]
		marker = L.marker([coordinates.Y, coordinates.X], icon: L.divIcon className: 'hc-map-icon').addTo(map)
		marker.bindPopup geoPopupTemplate(title, searchStr)
		map.fitBounds [[coordinates.Y, coordinates.X]]
		return
	, 'json'
	return
