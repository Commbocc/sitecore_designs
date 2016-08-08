# Table of Contents

* [Prerequisites](#prerequisites)
* [Map Container](#map-container-hcmap)
* [Map Objects](#map-objects-hcmapobject)
	* [Markers](#markers-hcmapmarker)
	* [Layers](#layers-hcmaplayer)
	* [Layer Groups](#layer-groups-hcmaplayergroup)

# *Prerequisites*

Assumes jQuery is included.

```HTML
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
```

Assumes Bootstrap files are included.

```HTML
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" crossorigin="anonymous">

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" crossorigin="anonymous"></script>
```

Assumes FontAwesome is included.

```HTML
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.1/css/font-awesome.min.css">
```

__Place stylesheets and scripts in layout.__

```HTML
<link href="/css/hc-map-leaflet.min.css" rel="stylesheet">
<link href="/css/hc-map.css" rel="stylesheet">

<script src="/js/leaflet.min.js"></script>
<script src="/js/leaflet-locate.min.js"></script>
<script src="/js/leaflet-esri.min.js"></script>
<script src="/js/hc-map-config.js"></script>
<!-- geosearch files -->
<script src="/js/leaflet-geosearch.min.js"></script>
<script src="/js/leaflet-geosearch-esri.min.js"></script>
```

# Map Container `HcMap`

```HTML
<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2" data-has-overlay="true">
		...
	</figure>
</div>
```

### Options

* `class="hc-map-v2"` _REQUIRED_
	* The `.hc-map-v2` class initializes the map.
* `data-has-overlay` _Boolean_ __true__ | false
	* Determines whether or not an overlay that allows certain features to be toggled on or off is displayed on top of the map. See the [Home map](https://commbocc.github.io/sitecore_designs/layouts/home/#hc-map-home) for an example.


# Map Objects `HcMapObject`

### Options

* `href` _URL_
* `data-name` _String_
* `data-icon-char` [_FontAwesome icon unicode_](http://glyphsearch.com/?copy=unicode&library=font-awesome)
* `data-icon-color` _Hex color code_ __#ff6f59__
* `data-visible` _Boolean_ __true__ | false
* `data-template` _Template filename_ __default__ | marker | cip | fema


## Markers `HcMapMarker`

```HTML
<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<marker data-name="Hillsborough County" data-latlng="28.173379, -82.823669" >
			Popup content can be placed here...
		</marker>
		<marker href="http://hcflgov.net/" data-name="Hillsborough County Center" data-address="601 E Kennedy Blvd, Tampa, FL 33602"></marker>
	</figure>
</div>
```

### Options

Extends the [`HcMapObject`](#map-objects-hcmapobject) class.

* `data-latlng` _Floating Pair_
* `data-address` _String_
* `data-template` _Template filename_ __marker__
	* When set to `marker`, content between the `<marker></marker>` tags will be displayed in the body of the popup.


## Layers `HcMapLayer`

```HTML
<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<layer data-id="9"></layer>
		<layer data-template="cip" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/InfoLayers/CIP_Layers/MapServer/1"></layer>
	</figure>
</div>
```

### Options

Extends the [`HcMapObject`](#map-objects-hcmapobject) class.

* `data-id` _Integer_
	* The layer identifier from [this ArcGIS map service](https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/).
* `data-url` _URL_
* `data-where` _SQL String_ (ex. `<layer data-id="9" data-where="DogPark <> ''"></layer>`)
	* Limits a layer's data points. The example above will show all parks, [layer 9](https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/9), where the `DogPark` field is not blank.


## Layer Groups `HcMapLayerGroup`

```HTML
<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<layerGroup data-name="County Public Offices" data-visible="true" data-icon-char="" data-icon-color="#fd9407">
			<layer data-name="Community Resource Centers" data-id="2"></layer>
			<layer data-name="Consumer Protection Offices" data-id="3"></layer>
			...
		</layerGroup>
	</figure>
</div>
```

### Options

Extends the [`HcMapObject`](#map-objects-hcmapobject) class.
