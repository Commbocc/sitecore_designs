(function() {
  var HcMapLayer, HcMapLayerGroup, HcMapMarker, HcMapObject, HcMapOverlay,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.HcMap = (function() {
    function HcMap(elem, templatesDir) {
      this.elem = elem;
      this.templatesDir = templatesDir;
      this.map = L.map(this.elem.get(0), {
        scrollWheelZoom: false
      });
      this.mapObjectElems = this.elem.find('> layer, > layerGroup, > marker');
      this.arcgisUrl = 'https://services.arcgis.com/apTfC6SUmnNfnxuF/arcgis/rest/services/HCWebMap/FeatureServer/';
      this.hasOverlays = _.isUndefined(this.elem.data('has-overlay')) ? false : this.elem.data('has-overlay');
      this.zoom = _.isUndefined(this.elem.data('zoom')) ? false : this.elem.data('zoom');
      this.clickToScroll = _.isUndefined(this.elem.data('click-scroll')) ? true : this.elem.data('click-scroll');
      this.mapObjects = [];
      this.overlayToggles = [];
      this.map.setView([0, 0], 10);
      L.esri.basemapLayer('Topographic').addTo(this.map);
      L.control.locate().addTo(this.map);
      this.northWest = L.latLng(28.173379, -82.823669);
      this.southEast = L.latLng(27.57055, -82.054012);
      this.map.fitBounds(L.latLngBounds(this.northWest, this.southEast));
      if (this.clickToScroll) {
        this.scrollWheelToggle();
      }
      this.createObjects();
      if (this.zoom) {
        this.zoomToFit();
      }
      if (this.hasOverlays) {
        new HcMapOverlay(this);
      }
    }

    HcMap.prototype.createObjects = function() {
      var self;
      self = this;
      return this.mapObjectElems.each(function() {
        var obj;
        switch ($(this).prop('tagName').toLowerCase()) {
          case 'layer':
            obj = new HcMapLayer($(this), self);
            break;
          case 'layergroup':
            obj = new HcMapLayerGroup($(this), self);
            break;
          case 'marker':
            obj = new HcMapMarker($(this), self);
        }
        self.mapObjects.push(obj);
        $(this).hide();
      });
    };

    HcMap.prototype.addGeoMarker = function(marker) {
      var geoClient, self;
      self = this;
      geoClient = new L.GeoSearch.Provider.Esri();
      return $.get(geoClient.GetServiceUrl(marker.address), function(data) {
        var coordinates;
        coordinates = geoClient.ParseJSON(data)[0];
        self.addCoordsMarker(marker, [coordinates.Y, coordinates.X]);
      }, 'json');
    };

    HcMap.prototype.addCoordsMarker = function(marker, coords) {
      var coordinates, leafletMarker;
      if (coords == null) {
        coords = false;
      }
      coordinates = coords ? coords : marker.latlng;
      leafletMarker = L.marker(coordinates, {
        icon: L.divIcon({
          className: null,
          html: marker.renderedIcon().get(0).outerHTML
        })
      });
      this.bindPopupFor(marker, leafletMarker);
      this.bindHrefFor(marker, leafletMarker);
      if (this.hasOverlays) {
        if (marker.visible) {
          return leafletMarker.addTo(this.map);
        }
      } else {
        return leafletMarker.addTo(this.map);
      }
    };

    HcMap.prototype.addHcLayer = function(layer) {
      var feature;
      feature = layer.feature();
      if (!_.isUndefined(layer.color)) {
        feature.setStyle({
          color: layer.color
        });
      }
      this.bindPopupFor(layer, feature);
      this.bindHrefFor(layer, feature);
      this.bindListFor(layer, feature);
      this.bindFilterFor(layer, feature);
      if (this.hasOverlays) {
        this.overlayToggles.push({
          obj: layer,
          leafletObj: feature
        });
        if (layer.visible) {
          return feature.addTo(this.map);
        }
      } else {
        return feature.addTo(this.map);
      }
    };

    HcMap.prototype.addHcLayerGroup = function(layerGroup) {
      var leafletGroup, self;
      self = this;
      leafletGroup = new L.layerGroup();
      $.each(layerGroup.layers, function(index, layer) {
        var feature;
        feature = layer.feature();
        self.bindPopupFor(layer, feature);
        self.bindHrefFor(layer, feature);
        leafletGroup.addLayer(feature);
      });
      if (this.hasOverlays) {
        this.overlayToggles.push({
          obj: layerGroup,
          leafletObj: leafletGroup
        });
        if (layerGroup.visible) {
          return leafletGroup.addTo(this.map);
        }
      } else {
        return leafletGroup.addTo(this.map);
      }
    };

    HcMap.prototype.bindPopupFor = function(obj, leafletObj) {
      $.get(this.templatesDir + 'popups/' + obj.popupProperties.template + '.html', function(templateData) {
        var template;
        template = _.template(templateData);
        leafletObj.bindPopup(function(e) {
          var templateProperties;
          templateProperties = obj.popupProperties.template !== 'default' ? e.feature.properties : obj.popupProperties;
          return L.Util.template(template({
            properties: templateProperties
          }), templateProperties);
        });
      }, 'html');
    };

    HcMap.prototype.bindHrefFor = function(obj, leafletObj) {
      if (!_.isUndefined(obj.href)) {
        return leafletObj.on('click', function() {
          return window.location = obj.href;
        });
      }
    };

    HcMap.prototype.scrollWheelToggle = function() {
      return this.map.on('click', function() {
        if (this.scrollWheelZoom.enabled()) {
          this.scrollWheelZoom.disable();
        } else {
          this.scrollWheelZoom.enable();
        }
      });
    };

    HcMap.prototype.zoomToFit = function() {
      var bounds;
      bounds = new L.latLngBounds();
      return this.map.on('layeradd', function(e) {
        if (e.layer._latlng && e.layer._icon) {
          bounds.extend(e.layer._latlng);
          this.fitBounds(bounds);
        }
      });
    };

    HcMap.prototype.bindListFor = function(obj, leafletObj) {
      var self;
      self = this;
      if (!(_.isUndefined(obj.listElem) || _.isUndefined(obj.listTemplate))) {
        return leafletObj.on('load', function(e) {
          var layers;
          layers = e.target._layers;
          return $.get(self.templatesDir + '/lists/' + obj.listTemplate + '.html', function(templateData) {
            var template;
            template = _.template(templateData);
            return $(obj.listElem).append(template({
              layers: layers
            }));
          });
        });
      }
    };

    HcMap.prototype.bindFilterFor = function(obj, leafletObj) {
      var self;
      self = this;
      if (!(_.isUndefined(obj.filterField) || _.isUndefined(obj.filterElem))) {
        return leafletObj.on('load', function(e) {
          var filters;
          filters = _.uniq(_.map(e.target._layers, function(layer) {
            return layer.feature.properties[obj.filterField];
          }));
          return $.get(self.templatesDir + '/filters/filter.html', function(templateData) {
            var template;
            template = _.template(templateData);
            return $(obj.filterElem).append(template({
              filter_field: obj.filterField,
              filters: filters
            }));
          });
        });
      }
    };

    return HcMap;

  })();

  HcMapObject = (function() {
    function HcMapObject(elem, map) {
      this.elem = elem;
      this.map = map;
      this.name = this.elem.data('name');
      this.href = this.elem.attr('href');
      this.icon = {
        char: _.isUndefined(this.elem.data('icon-char')) ? '' : this.elem.data('icon-char'),
        color: _.isUndefined(this.elem.data('icon-color')) ? '#ff6f59' : this.elem.data('icon-color')
      };
      this.visible = _.isUndefined(this.elem.data('visible')) ? false : this.elem.data('visible');
      this.popupProperties = {
        template: _.isUndefined(this.elem.data('template')) ? 'default' : this.elem.data('template'),
        title: this.name,
        content: this.elem.html()
      };
    }

    HcMapObject.prototype.renderedIcon = function() {
      return $('<div class="hc-map-icon"></div>').css({
        background: this.icon.color,
        boxShadow: '0 0 0 1px ' + this.icon.color
      }).html(this.icon.char);
    };

    return HcMapObject;

  })();

  HcMapMarker = (function(superClass) {
    extend(HcMapMarker, superClass);

    function HcMapMarker(elem, map) {
      this.elem = elem;
      this.map = map;
      HcMapMarker.__super__.constructor.call(this, this.elem, this.map);
      this.latlng = _.isUndefined(this.elem.data('latlng')) ? void 0 : this.elem.data('latlng').split(',');
      this.address = this.elem.data('address');
      if (!_.isUndefined(this.latlng)) {
        this.map.addCoordsMarker(this);
      } else if (!_.isUndefined(this.address)) {
        this.map.addGeoMarker(this);
      }
    }

    return HcMapMarker;

  })(HcMapObject);

  HcMapLayer = (function(superClass) {
    extend(HcMapLayer, superClass);

    function HcMapLayer(elem, map, inGroup) {
      this.elem = elem;
      this.map = map;
      if (inGroup == null) {
        inGroup = false;
      }
      HcMapLayer.__super__.constructor.call(this, this.elem, this.map);
      this.id = this.elem.data('id');
      this.color = this.elem.data('color');
      this.url = _.isUndefined(this.elem.data('url')) ? this.map.arcgisUrl + this.id : this.elem.data('url');
      if (!_.isUndefined(this.id && _.isUndefined(this.elem.data('template')))) {
        this.popupProperties.template = 'hc-arcgis';
      }
      this.whereClause = this.elem.data('where');
      this.listElem = this.elem.data('list-elem');
      this.listTemplate = this.elem.data('list-template');
      this.filterElem = this.elem.data('filter-elem');
      this.filterField = this.elem.data('filter-field');
      if (!inGroup) {
        this.map.addHcLayer(this);
      }
    }

    HcMapLayer.prototype.feature = function() {
      var self;
      self = this;
      return L.esri.featureLayer({
        url: this.url,
        where: self.where(),
        pointToLayer: function(esriFeature, latlng) {
          return L.marker(latlng, {
            icon: L.divIcon({
              className: null,
              html: self.renderedIcon().get(0).outerHTML
            })
          });
        }
      });
    };

    HcMapLayer.prototype.where = function() {
      var url;
      url = new UrlParser();
      if (!_.isUndefined(this.whereClause)) {
        return this.whereClause;
      } else if (url.params.filter !== void 0) {
        return this.filterField + " = '" + url.params.filter + "'";
      } else {
        return '';
      }
    };

    return HcMapLayer;

  })(HcMapObject);

  HcMapLayerGroup = (function(superClass) {
    extend(HcMapLayerGroup, superClass);

    function HcMapLayerGroup(elem, map) {
      this.elem = elem;
      this.map = map;
      HcMapLayerGroup.__super__.constructor.call(this, this.elem, this.map);
      this.layerElems = this.elem.find('> layer');
      this.layers = [];
      if (!_.isUndefined(this.elem.data('content'))) {
        this.popupProperties.content = this.elem.data('content');
      }
      this.initHcLayers();
      this.map.addHcLayerGroup(this);
    }

    HcMapLayerGroup.prototype.initHcLayers = function() {
      var self;
      self = this;
      return this.layerElems.each(function() {
        var layer;
        layer = new HcMapLayer($(this), self.map, true);
        if (!_.isUndefined(self.elem.attr('href'))) {
          layer.href = self.href;
        }
        layer.icon.char = self.icon.char;
        layer.icon.color = self.icon.color;
        if (!_.isUndefined(self.elem.data('template'))) {
          layer.popupProperties.template = self.popupProperties.template;
        }
        if (!_.isUndefined(self.elem.data('name'))) {
          layer.popupProperties.title = self.popupProperties.title;
        }
        if (!_.isUndefined(self.elem.data('content'))) {
          layer.popupProperties.content = self.elem.data('content');
        }
        return self.layers.push(layer);
      });
    };

    return HcMapLayerGroup;

  })(HcMapObject);

  HcMapOverlay = (function() {
    function HcMapOverlay(map) {
      var self;
      this.map = map;
      self = this;
      $.get(this.map.templatesDir + 'overlays.html', function(templateData) {
        var $template, $toggles, template;
        template = _.template(templateData);
        $template = $(template({
          properties: {}
        }));
        $toggles = $template.find('#map-overlay-toggles');
        $(document).click(function(event) {
          var $overlays, _opened;
          $overlays = $template.find('#map-overlays');
          _opened = $overlays.hasClass('in');
          if (_opened === true) {
            $overlays.removeClass('in');
          }
        });
        $.each(self.map.overlayToggles, function(index, overlay) {
          var $toggle;
          $toggle = $('<a href="#" class="map-overlay-toggle"></a>').html(overlay.obj.renderedIcon().get(0).outerHTML + '&nbsp;' + overlay.obj.name);
          if (self.map.map.hasLayer(overlay.leafletObj)) {
            $toggle.addClass('active');
          }
          $toggle.on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            if (self.map.map.hasLayer(overlay.leafletObj)) {
              self.map.map.removeLayer(overlay.leafletObj);
              $toggle.removeClass('active');
            } else {
              self.map.map.addLayer(overlay.leafletObj);
              $toggle.addClass('active');
            }
          });
          $toggles.append($toggle);
        });
        self.map.elem.before($template);
      }, 'html');
    }

    return HcMapOverlay;

  })();

  window.UrlParser = (function() {
    function UrlParser(url) {
      var a;
      if (url == null) {
        url = window.location.href;
      }
      a = document.createElement('a');
      a.href = url;
      this.source = url;
      this.path = a.pathname.replace(/^([^\/])/, '/$1');
      this.protocol = a.protocol.replace(':', '');
      this.host = a.hostname;
      this.port = a.port;
      this.query = a.search;
      this.hash = a.hash.replace('#', '');
      this.params = this.getParams(a);
      this.fullPath = this.getFullPath();
    }

    UrlParser.prototype.getFullPath = function() {
      return this.path + this.query;
    };

    UrlParser.prototype.getParams = function(a) {
      var i, len, ret, s, seg;
      ret = {};
      seg = a.search.replace(/^\?/, '').split('&');
      len = seg.length;
      i = 0;
      s = void 0;
      while (i < len) {
        if (!seg[i]) {
          i++;
          continue;
        }
        s = seg[i].split('=');
        ret[s[0]] = s[1];
        i++;
      }
      return ret;
    };

    return UrlParser;

  })();

}).call(this);
