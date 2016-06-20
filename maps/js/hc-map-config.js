(function() {
  var addLayerToMapAndMapOverlaysPanel, defaultPopupTemplate, geoPopupTemplate, setGeoMarker, toggleScrollWheel;

  $(function() {
    var map_service;
    map_service = 'https://maps.hillsboroughcounty.org/arcgis/rest/services/CoinMap/CountyWebsiteRedesignMap_20160609/MapServer/';
    $.fn.initHcMap = function() {
      var map, northWest, southEast;
      map = L.map($(this).attr('id'), {
        scrollWheelZoom: false
      });
      map.setView([0, 0], 10);
      toggleScrollWheel(map);
      L.esri.basemapLayer('Topographic').addTo(map);
      L.control.locate().addTo(map);
      northWest = L.latLng(28.173379, -82.823669);
      southEast = L.latLng(27.57055, -82.054012);
      map.fitBounds(L.latLngBounds(northWest, southEast));
      return map;
    };
    $('#home-map').each(function() {
      var layers, map;
      map = $(this).initHcMap();
      layers = [
        {
          name: 'County Public Offices',
          visible: true,
          urls: [map_service + '2', map_service + '3', map_service + '12', map_service + '10', map_service + '4', map_service + '16'],
          iconClass: 'hc-map-icon-public-office'
        }, {
          name: 'Community Collection Centers',
          visible: false,
          urls: [map_service + '1'],
          iconClass: 'hc-map-icon-collection-center'
        }, {
          name: 'Senior Centers',
          visible: false,
          urls: [map_service + '13'],
          iconClass: 'hc-map-icon-senior-center'
        }, {
          name: 'Parks and Recreation Sites',
          visible: false,
          urls: [map_service + '9'],
          iconClass: 'hc-map-icon-park'
        }, {
          name: 'Constitutional Offices',
          visible: false,
          urls: [map_service + '15', map_service + '0', map_service + '14', map_service + '6', map_service + '11'],
          iconClass: 'hc-map-icon-const-office'
        }, {
          name: 'Fire Stations',
          visible: false,
          urls: [map_service + '5'],
          iconClass: 'hc-map-icon-fire-station'
        }, {
          name: 'Libraries',
          visible: false,
          urls: [map_service + '8'],
          iconClass: 'hc-map-icon-library'
        }
      ];
      $(document).click(function(event) {
        var _opened;
        _opened = $('#map-overlays').hasClass('in');
        if (_opened === true) {
          $('#map-overlays').removeClass('in');
        }
      });
      $.each(layers, function(index, layer) {
        var layer_group;
        layer_group = L.layerGroup();
        $.each(layer.urls, function(l_index, url) {
          var new_layer;
          new_layer = L.esri.featureLayer({
            url: url,
            pointToLayer: function(esriFeature, latlng) {
              return L.marker(latlng, {
                icon: L.divIcon({
                  className: 'hc-map-icon ' + layer.iconClass
                })
              });
            }
          });
          new_layer.bindPopup(function(e) {
            var properties;
            properties = e.feature.properties;
            return L.Util.template(defaultPopupTemplate(properties), properties);
          });
          layer_group.addLayer(new_layer);
        });
        addLayerToMapAndMapOverlaysPanel(map, layer_group, layer);
      });
    });
    $('.hc-map-layer').each(function() {
      var layer, layer_str, map;
      map = $(this).initHcMap();
      if (!($(this).data('layer') === void 0 || $(this).data('layer') === '')) {
        if ($(this).data('layer').toString().indexOf("http") !== -1) {
          layer_str = $(this).data('layer');
        } else {
          layer_str = map_service + $(this).data('layer');
        }
        layer = L.esri.featureLayer({
          url: layer_str,
          pointToLayer: function(esriFeature, latlng) {
            return L.marker(latlng, {
              icon: L.divIcon({
                className: 'hc-map-icon'
              })
            });
          }
        });
        layer.bindPopup(function(e) {
          var properties;
          properties = e.feature.properties;
          return L.Util.template(defaultPopupTemplate(properties), properties);
        });
        layer.on('createfeature', function() {
          var bounds;
          bounds = [];
          $.each($(this)[0]._layers, function(index, marker) {
            bounds.push(marker._latlng);
          });
          if (!$.inArray(bounds, void 0)) {
            map.fitBounds(bounds);
          }
        });
        map.addLayer(layer);
      }
    });
    return $('.hc-map-geo').each(function() {
      var map;
      map = $(this).initHcMap();
      setGeoMarker($(this).data('name'), $(this).data('address'), map);
    });
  });

  defaultPopupTemplate = function(properties) {
    var directions_str, out;
    directions_str = [properties.WEB_ADDRESS, properties.WEB_CITY, 'FL', properties.WEB_ZIP].join('+').replace(/[^0-9a-z]/gi, '+').replace(' ', '+');
    out = "<h4 class=\"popover-title\">{WEB_NAME}</h4>\n<div class=\"popover-content\">\n	<p>\n		{WEB_ADDRESS}<br>\n		{WEB_CITY}, FL {WEB_ZIP}<br>\n		<a href=\"https://www.google.com/maps/dir//" + directions_str + "\" target=\"_blank\" class=\"small pull-right\">Directions</a>\n</p>";
    if (properties.WEB_URL !== null && properties.WEB_URL !== '') {
      out += "<p>\n	<a href=\"{WEB_URL}\" class=\"btn btn-secondary btn-sm btn-block\">Learn More</a>\n</p>";
    }
    out += "</div>";
    return out;
  };

  geoPopupTemplate = function(title, address) {
    var directions_str, out;
    directions_str = [address].join('+').replace(/[^0-9a-z]/gi, '+').replace(' ', '+');
    out = "<h4 class=\"popover-title\">" + title + "</h4>\n<div class=\"popover-content\">\n	<p>" + address + "<br>\n<a href=\"https://www.google.com/maps/dir//" + directions_str + "\" target=\"_blank\" class=\"small pull-right\">Directions</a>\n</p>";
    out += "</div>";
    return out;
  };

  toggleScrollWheel = function(map) {
    map.on('click', function() {
      if (map.scrollWheelZoom.enabled()) {
        map.scrollWheelZoom.disable();
      } else {
        map.scrollWheelZoom.enable();
      }
    });
  };

  addLayerToMapAndMapOverlaysPanel = function(map, layer, obj) {
    var $toggle;
    $toggle = $('<a href="#" class="map-overlay-toggle"></a>');
    $toggle.html('<span class="hc-map-icon ' + obj.iconClass + '"></span> ' + obj.name);
    if (obj.visible) {
      layer.addTo(map);
      $toggle.appendTo('#map-overlay-toggles').addClass('active');
    } else {
      $toggle.appendTo('#map-overlay-toggles');
    }
    $toggle.on('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      if (map.hasLayer(layer)) {
        map.removeLayer(layer);
        $(this).removeClass('active');
      } else {
        map.addLayer(layer);
        $(this).addClass('active');
      }
    });
  };

  setGeoMarker = function(title, searchStr, map) {
    var client, json_url;
    client = new L.GeoSearch.Provider.Esri();
    json_url = client.GetServiceUrl(searchStr);
    $.get(json_url, function(data) {
      var coordinates, marker;
      coordinates = client.ParseJSON(data)[0];
      marker = L.marker([coordinates.Y, coordinates.X], {
        icon: L.divIcon({
          className: 'hc-map-icon'
        })
      }).addTo(map);
      marker.bindPopup(geoPopupTemplate(title, searchStr));
      map.fitBounds([[coordinates.Y, coordinates.X]]);
    }, 'json');
  };

}).call(this);
