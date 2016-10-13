---
---

$ ->

	apexAPI = '/sitecore_designs/animalabusers/data.json'
	# var apexAPI = "https://apex-pub.hillsboroughcounty.org/apex/bocc.caar_get_json";

	url = new UrlParser()
	search_str = url.params.q
	sort_by = url.params.s

	$results_elem = $('#animalabusers')
	$results_elem_clone = $results_elem.clone()

	unless _.isEmpty(url.params)
		$('html, body').animate { scrollTop: $results_elem.offset().top }, 1000

	$.getJSON(apexAPI).always (data) ->

		abusers = data['abuser registry'].abusers

		# search filter
		unless _.isUndefined(search_str)
			abusers = _.filter abusers, (x) ->
				regex = new RegExp(search_str+'.*', 'i')
				key_values = _.map x, (value) ->
					if value.match regex
						return true
				return _.contains(key_values, true)
			$('#search-animalabusers').val(search_str)

		# order by
		unless _.isUndefined(sort_by)
			abusers = _.sortBy abusers, sort_by
			$('#sort-animalabusers').val(sort_by)

		# has results?
		if _.isEmpty(abusers)
			$results_elem.replaceWith($results_elem_clone.clone())
		else
			$results_elem.html(null)

		$.get '/sitecore_designs/animalabusers/templates/abusers.html', (templateData) ->
			template = _.template(templateData)
			_.each abusers, (abuser) ->
				$results_elem.append(template(abuser: abuser))
				return
			return
		, 'html'
		return

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
