Jekyll::Hooks.register :site, :post_write do |site|
	# code to call after Jekyll writes the site
	sass = HcMap::Init.new(site)
end

module HcMap

	class Init
		def initialize(site)

			# config files
			FileUtils.cp "#{site.in_dest_dir}/css/hc-map.css", "#{site.in_source_dir}/maps/css/hc-map.css"
			FileUtils.cp "#{site.in_dest_dir}/js/hc-map.js", "#{site.in_source_dir}/maps/js/hc-map.js"
			FileUtils.cp "#{site.in_dest_dir}/js/hc-map-init.js", "#{site.in_source_dir}/maps/js/hc-map-init.js"

			# vendor files
			FileUtils.cp "#{site.in_dest_dir}/css/hc-map-leaflet.min.css", "#{site.in_source_dir}/maps/css/hc-map-leaflet.min.css"
			FileUtils.cp "#{site.in_dest_dir}/js/underscore.min.js", "#{site.in_source_dir}/maps/js/underscore.min.js"
			FileUtils.cp "#{site.in_dest_dir}/js/leaflet-esri.min.js", "#{site.in_source_dir}/maps/js/leaflet-esri.min.js"
			FileUtils.cp "#{site.in_dest_dir}/js/leaflet-geosearch-esri.min.js", "#{site.in_source_dir}/maps/js/leaflet-geosearch-esri.min.js"
			FileUtils.cp "#{site.in_dest_dir}/js/leaflet-geosearch.min.js", "#{site.in_source_dir}/maps/js/leaflet-geosearch.min.js"
			FileUtils.cp "#{site.in_dest_dir}/js/leaflet-locate.min.js", "#{site.in_source_dir}/maps/js/leaflet-locate.min.js"
			FileUtils.cp "#{site.in_dest_dir}/js/leaflet.min.js", "#{site.in_source_dir}/maps/js/leaflet.min.js"

		end
	end

end
