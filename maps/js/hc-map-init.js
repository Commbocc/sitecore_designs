(function() {
  $(function() {
    return $('.hc-map-v2').each(function() {
      var map;
      map = new HcMap($(this), "/sitecore_designs/maps/templates/");
    });
  });

}).call(this);
