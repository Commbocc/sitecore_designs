---
layout: hc-sidebar
title: Maps Demos
back: Lorem Ipsum
permalink: /maps/demos/
---

### Home

{% include home-map.html %}

### Road & Lane Closures
<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<layer data-name="Road & Lane Closures" data-color="#ff0000" data-template="road_lane" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesign_RoadClosures_20160817/MapServer/0"></layer>
	</figure>
</div>

### Commissioner Districts

<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<layer data-name="District 1" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/SandraMurmanDistrict1/MapServer/0">
			Sandra Murman
		</layer>
		<layer data-name="District 2" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/VictorCristDistrict2/MapServer/0">
			Victor Crist
		</layer>
		<layer data-name="District 3" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/LesleyMillerDistrict3/MapServer/0">
			Lesley Miller
		</layer>
		<layer data-name="District 4" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/StacyWhiteDistrict4/MapServer/0">
			Stacy White
		</layer>
	</figure>
</div>

#### Countywide example

<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<layerGroup data-name="District 5, Countywide" data-content="Ken Hagan">
			<layer data-name="District 1" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/SandraMurmanDistrict1/MapServer/0">
				Sandra Murman
			</layer>
			<layer data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/VictorCristDistrict2/MapServer/0"></layer>
			<layer data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/LesleyMillerDistrict3/MapServer/0"></layer>
			<layer data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/Commissioners/StacyWhiteDistrict4/MapServer/0"></layer>
		</layerGroup>
	</figure>
</div>

### Markers

<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2" data-zoom="true">
		<marker data-name="Address" data-address="601 E Kennedy Blvd, Tampa, FL 33602">
			Popup content can be placed here...
		</marker>
		<marker href="http://hillsclerk.com/" data-name="Clerk of Court" data-address="800 E Twiggs St #101, Tampa, FL 33602"></marker>
	</figure>
</div>

### CIP
<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<layer data-name="CIP" data-template="cip" data-url="https://maps.hillsboroughcounty.org/arcgis/rest/services/InfoLayers/CIP_Layers/MapServer/1"></layer>
	</figure>
</div>

### Flood Hazard Map

<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2">
		<layer data-template="fema" data-url="//hazards.fema.gov/gis/nfhl/rest/services/public/NFHL/MapServer/3"></layer>
	</figure>
</div>

### Dog Parks

<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2" data-zoom="true">
		<layer data-id="9" data-where="DogPark <> ''"></layer>
	</figure>
</div>

### Recreation Centers

<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2" data-zoom="true">
		<marker data-name="Keystone Recreation Center" data-address="17928 Gunn Highway Odessa, FL 33556"></marker>
		<marker data-name="Apollo Beach Recreation Center" data-address="664 Golf and Sea Blvd. Apollo Beach, FL 33615"></marker>
		<marker data-name="Brandon Recreation Center" data-address="502 E Sadie St, Brandon, FL 33510">813-635-7819 </marker>
		<marker data-name="Egypt Lake Recreation Center" data-address="3126 W Lambright St, Tampa, FL 33614">813-975-2103</marker>
		<marker data-name="Emanuel P. Johnson Recreation Center" data-address="5855 S. 78th Street, Tampa, FL 33619">813-671-7700</marker>
		<marker data-name="Gardenville Recreation Center" data-address="6219 Symmes Rd, Gibsonton, FL 33534">813-672-1120</marker>
		<marker data-name="Jackson Springs Recreation Center" data-address="8620 Jackson Springs Rd, Tampa, FL 33615">813-554-5004</marker>
		<marker data-name="Mango Recreation Center" data-address="11717 Clay Pit Rd, Seffner, FL 33584">813-635-7489</marker>
		<marker data-name="Northdale Recreation Center" data-address="15550 Spring Pine Dr, Tampa, FL 33624">(813) 264-8956</marker>
		<marker data-name="Thonotosassa Recreation Center" data-address="10132 Skewlee Rd, Thonotosassa, FL 33592">813-987-6206</marker>
		<marker data-name="Ruskin Recreation Center" data-address="901 6th Street SE, Ruskin, FL 33570">813-672-7881</marker>
		<marker data-name="Roy Haynes Recreation Center" data-address="1902 South Village Ave, Tampa, FL 33612">813-903-3480</marker>
		<marker data-name="Westchase Recreation Center" data-address="9791 Westchase Dr, Tampa, FL 33626">(813) 964-2948</marker>
		<marker data-name="All People's Life Center" data-address="6105 E. Sligh Ave, Tampa, FL 33617">813-744-5978</marker>
	</figure>
</div>

### CORE Locations

<div class="embed-responsive embed-responsive-16by9 thumbnail">
	<figure class="hc-map-v2" data-zoom="true">
		<marker data-name="Bartels Middle School" data-address="9020 Imperial Oak Blvd. Tampa, Fl 33647">
			9020 Imperial Oak Blvd. Tampa, Fl 33647
		</marker>
		<marker data-name="Burnett Middle School" data-address="1010 North Kingsway Rd. Seffner, Fl 33584">
			1010 North Kingsway Rd. Seffner, Fl 33584
		</marker>
		<marker data-name="Sergeant Paul R. Smith Middle School" data-address="14303 Citrus Pointe Dr. Tampa, Fl 33625">
			14303 Citrus Pointe Dr. Tampa, Fl 33625
		</marker>
		<marker data-name="Shields Middle School" data-address="15732 Beth Shields Way Ruskin, Fl 33573">
			15732 Beth Shields Way Ruskin, Fl 33573
		</marker>
	</figure>
</div>
