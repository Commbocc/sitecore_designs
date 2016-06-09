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

		# layers
		layers = [
			{
				name: 'County Public Offices'
				visible: true
				urls: [
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/2' # Community Resource Centers
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/3' # Consumer Protection Offices
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/12' # Customer Service Center for Public Utilities
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/10' # Pet Resource Center
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/4' # County Center
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/16' # Veterans Services Offices
				]
				iconClass: 'hc-map-icon-public-office'
			}
			{
				name: 'Community Collection Centers'
				visible: false
				urls: [
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/1' # Community Collection Centers
				]
				iconClass: 'hc-map-icon-collection-center'
			}
			{
				name: 'Senior Centers'
				visible: false
				urls: [
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/13' # Community Collection Centers
				]
				iconClass: 'hc-map-icon-senior-center'
			}
			{
				name: 'Parks and Recreation Sites'
				visible: false
				urls: [
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/9' # Parks
				]
				iconClass: 'hc-map-icon-park'
			}
			{
				name: 'Constitutional Offices'
				visible: false
				urls: [
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/15' # Tax Collector Locations
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/0' # Clerk of Court Locations
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/14' # Supervisor of Elections Locations
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/6' # Hillsborough County Sheriff Office Locations
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/11' # Property Appraiser Locations
				]
				iconClass: 'hc-map-icon-const-office'
			}
			{
				name: 'Fire Stations'
				visible: false
				urls: [
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/5' # Fire Stations
				]
				iconClass: 'hc-map-icon-fire-station'
			}
			{
				name: 'Libraries'
				visible: false
				urls: [
					'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/8' # Libraries
				]
				iconClass: 'hc-map-icon-library'
			}
		]

		# layer toggle container
		overlay_toggles_elem = document.getElementById 'map-overlay-toggles'

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
