---
---

$ ->

	# layer toggle container
	layers = document.getElementById 'nav-mapbox'

	# add Layer function
	addFeatureLayer = (layer, name, zIndex) ->
		layer.addTo map
		link = document.createElement('a')
		link.href = '#'
		link.className = 'list-group-item'
		link.innerHTML = '<i class="fa fa-check-square fa-fw"></i>&nbsp;' + name
		# layer toggle function
		link.onclick = (e) ->
			e.preventDefault()
			e.stopPropagation()
			if map.hasLayer(layer)
				map.removeLayer layer
				@innerHTML = '<i class="fa fa-square fa-fw"></i>&nbsp;' + name
			else
				map.addLayer layer
				@innerHTML = '<i class="fa fa-check-square fa-fw"></i>&nbsp;' + name
			return
		layers.appendChild link
		return

	# init map
	map = L.map('home-map').setView([27.988945, -82.507324], 10);
	L.control.locate().addTo map
	L.esri.basemapLayer('Streets').addTo map

	# layers
	hospitals = L.esri.featureLayer
		url: 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/County_Webmap/MapServer/0'
		pointToLayer: (esriFeature, latlng) ->
			L.marker latlng, icon: L.icon
				iconUrl: 'https://cdn4.iconfinder.com/data/icons/medical-14/512/7-512.png'
				iconRetinaUrl: 'https://cdn4.iconfinder.com/data/icons/medical-14/512/7-512.png'
				iconSize: [25 ,25]
				popupAnchor: [0, -15]

	hospitalTemplate = '<h4>{NAME}</h4>{ADDRESS}'
	hospitals.bindPopup (e) ->
		L.Util.template hospitalTemplate, e.feature.properties

	addFeatureLayer hospitals, 'Hospitals', 1
