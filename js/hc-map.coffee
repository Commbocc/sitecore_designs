---
---

class window.HcMap
	constructor: (@elem, @templatesDir) ->
		@map = L.map @elem.get(0), {scrollWheelZoom: false}
		@mapObjectElems = @elem.find '> layer, > layerGroup, > marker'
		@arcgisUrl = 'https://services.arcgis.com/apTfC6SUmnNfnxuF/arcgis/rest/services/HCWebMap/FeatureServer/'
		@hasOverlays = if _.isUndefined @elem.data('has-overlay') then false else @elem.data('has-overlay')
		@zoom = if _.isUndefined @elem.data('zoom') then false else @elem.data('zoom')
		@clickToScroll = if _.isUndefined @elem.data('click-scroll') then true else @elem.data('click-scroll')
		@mapObjects = []
		@overlayToggles = []

		@map.setView [0,0], 10
		L.esri.basemapLayer('Topographic').addTo @map
		L.control.locate().addTo @map
		@northWest = L.latLng(28.173379, -82.823669) # Hillsborough County Boundaries
		@southEast = L.latLng(27.57055, -82.054012) # Hillsborough County Boundaries
		@map.fitBounds L.latLngBounds(@northWest, @southEast)

		@scrollWheelToggle() if @clickToScroll
		@createObjects()
		@zoomToFit() if @zoom
		new HcMapOverlay(@) if @hasOverlays

	createObjects: ->
		self = @
		@mapObjectElems.each ->
			switch $(this).prop('tagName').toLowerCase()
				when 'layer'
					obj = new HcMapLayer($(this), self)
				when 'layergroup'
					obj = new HcMapLayerGroup($(this), self)
				when 'marker'
					obj = new HcMapMarker($(this), self)
			self.mapObjects.push obj
			$(this).hide()
			return

	addGeoMarker: (marker) ->
		self = @
		geoClient = new L.GeoSearch.Provider.Esri()
		$.get geoClient.GetServiceUrl(marker.address), (data) ->
			coordinates = geoClient.ParseJSON(data)[0]
			self.addCoordsMarker(marker, [coordinates.Y, coordinates.X])
			return
		, 'json'

	addCoordsMarker: (marker, coords=false) ->
		coordinates = if coords then coords else marker.latlng
		leafletMarker = L.marker coordinates, icon: L.divIcon className: null, html: marker.renderedIcon().get(0).outerHTML
		@bindPopupFor marker, leafletMarker
		@bindHrefFor marker, leafletMarker
		if @hasOverlays
			leafletMarker.addTo @map if marker.visible
		else
			leafletMarker.addTo @map

	addHcLayer: (layer) ->
		feature = layer.feature()
		feature.setStyle({color: layer.color}) unless _.isUndefined layer.color
		@bindPopupFor layer, feature
		@bindHrefFor layer, feature
		@bindListFor layer, feature
		@bindFilterFor layer, feature
		if @hasOverlays
			@overlayToggles.push {obj: layer, leafletObj: feature}
			feature.addTo @map if layer.visible
		else
			feature.addTo @map

	addHcLayerGroup: (layerGroup) ->
		self = @
		leafletGroup = new L.layerGroup()

		$.each layerGroup.layers, (index, layer) ->
			feature = layer.feature()
			self.bindPopupFor(layer, feature)
			self.bindHrefFor(layer, feature)
			leafletGroup.addLayer feature
			return

		if @hasOverlays
			@overlayToggles.push {obj: layerGroup, leafletObj: leafletGroup}
			leafletGroup.addTo @map if layerGroup.visible
		else
			leafletGroup.addTo @map

	bindPopupFor: (obj, leafletObj) ->
		$.get @templatesDir + 'popups/' + obj.popupProperties.template + '.html', (templateData) ->
			template = _.template templateData
			leafletObj.bindPopup (e) ->
				templateProperties = if obj.popupProperties.template != 'default' then e.feature.properties else obj.popupProperties
				L.Util.template template({properties: templateProperties}), templateProperties
			return
		, 'html'
		return

	bindHrefFor: (obj, leafletObj) ->
		unless _.isUndefined obj.href
			leafletObj.on 'click', ->
				window.location = obj.href

	scrollWheelToggle: ->
		@map.on 'click', ->
			if @scrollWheelZoom.enabled()
				@scrollWheelZoom.disable()
			else
				@scrollWheelZoom.enable()
			return

	zoomToFit: ->
		bounds = new L.latLngBounds()
		@map.on 'layeradd', (e) ->
			if e.layer._latlng && e.layer._icon
				bounds.extend e.layer._latlng
				@fitBounds bounds
			return

	bindListFor: (obj, leafletObj) ->
		self = @
		unless _.isUndefined(obj.listElem) || _.isUndefined(obj.listTemplate)
			leafletObj.on 'load', (e) ->
				layers = e.target._layers
				$.get self.templatesDir + '/lists/'+obj.listTemplate+'.html', (templateData) ->
					template = _.template(templateData)
					$(obj.listElem).append(template(layers: layers))

	bindFilterFor: (obj, leafletObj) ->
		self = @
		unless _.isUndefined(obj.filterField) || _.isUndefined(obj.filterElem)
			leafletObj.on 'load', (e) ->
				filters = _.uniq _.map(e.target._layers, (layer) -> layer.feature.properties[obj.filterField])
				$.get self.templatesDir + '/filters/filter.html', (templateData) ->
					template = _.template(templateData)
					$(obj.filterElem).append(template(filter_field: obj.filterField, filters: filters))

class HcMapObject
	constructor: (@elem, @map) ->
		@name = @elem.data('name')
		@href = @elem.attr('href')

		@icon =
			char: if _.isUndefined @elem.data('icon-char') then '' else @elem.data('icon-char')
			color: if _.isUndefined @elem.data('icon-color') then '#ff6f59' else @elem.data('icon-color')

		@visible = if _.isUndefined @elem.data('visible') then false else @elem.data('visible')

		@popupProperties =
			template: if _.isUndefined @elem.data('template') then 'default' else @elem.data('template')
			title: @name
			content: @elem.html()

	renderedIcon: ->
		$('<div class="hc-map-icon"></div>').css(
			background: @icon.color
			boxShadow: '0 0 0 1px ' + @icon.color).html(@icon.char)

class HcMapMarker extends HcMapObject
	constructor: (@elem, @map) ->
		super(@elem, @map)
		@latlng = if _.isUndefined @elem.data('latlng') then undefined else @elem.data('latlng').split(',')
		@address = @elem.data('address')
		if !_.isUndefined @latlng
			@map.addCoordsMarker(@)
		else if !_.isUndefined @address
			@map.addGeoMarker(@)

class HcMapLayer extends HcMapObject
	constructor: (@elem, @map, inGroup=false) ->
		super(@elem, @map)
		@id = @elem.data('id')
		@color = @elem.data('color')
		@url = if _.isUndefined @elem.data('url') then @map.arcgisUrl + @id else @elem.data('url')
		@popupProperties.template = 'hc-arcgis' unless _.isUndefined @id && _.isUndefined @elem.data('template')
		@whereClause = @elem.data('where')
		@listElem = @elem.data('list-elem')
		@listTemplate = @elem.data('list-template')
		@filterElem = @elem.data('filter-elem')
		@filterField = @elem.data('filter-field')
		@map.addHcLayer(@) unless inGroup

	feature: ->
		self = @
		return L.esri.featureLayer
			url: @url
			where: self.where()
			pointToLayer: (esriFeature, latlng) ->
				L.marker latlng, icon: L.divIcon className: null, html: self.renderedIcon().get(0).outerHTML

	where: ->
		url = new UrlParser()
		if !_.isUndefined(@whereClause)
			return @whereClause
		else if url.params.filter != undefined
			return @filterField+" = '"+url.params.filter+"'"
		else
			return ''

class HcMapLayerGroup extends HcMapObject
	constructor: (@elem, @map) ->
		super(@elem, @map)
		@layerElems = @elem.find('> layer')
		@layers = []
		@popupProperties.content = @elem.data('content') unless _.isUndefined @elem.data('content')
		@initHcLayers()
		@map.addHcLayerGroup(@)

	initHcLayers: ->
		self = @
		@layerElems.each ->
			layer = new HcMapLayer($(this), self.map, true)
			layer.href = self.href unless _.isUndefined self.elem.attr('href')
			layer.icon.char = self.icon.char
			layer.icon.color = self.icon.color
			layer.popupProperties.template = self.popupProperties.template unless _.isUndefined self.elem.data('template')
			layer.popupProperties.title = self.popupProperties.title unless _.isUndefined self.elem.data('name')
			layer.popupProperties.content = self.elem.data('content') unless _.isUndefined self.elem.data('content')
			self.layers.push layer

class HcMapOverlay
	constructor: (@map) ->
		self = @
		$.get @map.templatesDir + 'overlays.html', (templateData) ->
			template = _.template templateData
			$template = $(template properties: {})
			$toggles = $template.find('#map-overlay-toggles')

			# close overlay on click anywhere else
			$(document).click (event) ->
				$overlays = $template.find('#map-overlays')
				_opened = $overlays.hasClass('in')
				if _opened == true
					$overlays.removeClass('in')
				return

			$.each self.map.overlayToggles, (index, overlay) ->
				$toggle = $('<a href="#" class="map-overlay-toggle"></a>').html(
					overlay.obj.renderedIcon().get(0).outerHTML + '&nbsp;' + overlay.obj.name)

				$toggle.addClass 'active' if self.map.map.hasLayer overlay.leafletObj

				$toggle.on 'click', (e) ->
					e.preventDefault()
					e.stopPropagation()
					if self.map.map.hasLayer overlay.leafletObj
						self.map.map.removeLayer overlay.leafletObj
						$toggle.removeClass 'active'
					else
						self.map.map.addLayer overlay.leafletObj
						$toggle.addClass 'active'
					return

				$toggles.append $toggle
				return

			self.map.elem.before $template
			return
		, 'html'

class window.UrlParser
	constructor: (url = window.location.href) ->
		a = document.createElement('a')
		a.href = url
		@source = url
		@path = a.pathname.replace(/^([^/])/,'/$1')
		@protocol = a.protocol.replace(':','')
		@host = a.hostname
		@port = a.port
		@query = a.search
		@hash = a.hash.replace('#','')
		@params = @getParams(a)
		@fullPath = @getFullPath()

	getFullPath: ->
		return @path + @query

	getParams: (a) ->
		ret = {}
		seg = a.search.replace(/^\?/,'').split('&')
		len = seg.length
		i = 0
		s = undefined
		while i < len
			if !seg[i]
				i++
				continue
			s = seg[i].split('=')
			ret[s[0]] = s[1]
			i++
		return ret
