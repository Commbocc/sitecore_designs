---
---

$ ->

	# init map
	map = L.map('home-map').setView([27.988945, -82.507324], 10);
	L.control.locate().addTo map
	L.esri.basemapLayer('Streets').addTo map

	# layer toggle container
	overlay_toggles_elem = document.getElementById 'map-overlay-toggles'

	# layers
	layers = [
		{
			name: 'Hospitals'
			visible: false
			url: 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/County_Webmap/MapServer/0'
			iconUrl: 'https://cdn4.iconfinder.com/data/icons/medical-14/512/7-512.png'
			popupTemplate: '<h4>{NAME}</h4>{ADDRESS}'
		}
		{
			name: 'Senior Centers'
			visible: true
			url: 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/County_Webmap/MapServer/1'
			iconUrl: 'http://12991002.sites.myregisteredsite.com/files/108152360.png'
			popupTemplate: '<h4>{NAME}</h4>{ADDRESS}'
		}
		{
			name: 'Fire Stations'
			visible: false
			url: 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/County_Webmap/MapServer/2'
			iconUrl: 'http://www.ifssgroup.com/wp-content/uploads/2016/01/fire-icon-287x300.png'
			popupTemplate: '<h4>{NAME}</h4>{ADDRESS}'
		}
	]

	# add Layer function
	addFeatureLayer = (layer, obj) ->
		toggle = document.createElement('a')
		toggle.href = '#'
		toggle.className = 'map-overlay-toggle'
		toggle.innerHTML = '<img src="'+obj.iconUrl+'" alt="'+obj.name+'" width="25" /> ' + obj.name
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
				L.marker latlng, icon: L.icon
					iconUrl: layer.iconUrl
					# iconRetinaUrl:
					iconSize: [25 ,25]
					popupAnchor: [0, -15]
		new_layer.bindPopup (e) ->
			L.Util.template layer.popupTemplate, e.feature.properties
		addFeatureLayer new_layer, layer
		return
