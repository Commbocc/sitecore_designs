# Jekyll::Hooks.register :site, :pre_render do |site|
# 	# code to call after Jekyll writes the site
# 	theme = Development::Theme.new(site)
# end
#
# module Development
#
# 	class Theme
# 		def initialize(site)
# 			@sass_dir = "#{site.in_source_dir}/_sass"
# 			@theme_file = "#{@sass_dir}/_theme.scss"
# 			@theme_dir = "#{@sass_dir}/theme"
# 			@files = Dir["#{@theme_dir}/**/*.scss"]
#
# 			edit_file
# 		end
#
# 		private
#
# 		def edit_file
# 			f = File.open @theme_file, "w+"
# 			@files.each do |file|
# 				filename = File.basename(file, ".*")
# 				filename.slice!(0)
# 				f.write "@import \"theme/#{filename}\";\n" unless filename == '_variables'
# 			end
# 			f.close
# 		end
#
# 	end
#
# end
