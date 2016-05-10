---
---

$ ->

	# nav hover collapse
	# .service-groups

	$('.nav-primary-link').hover (->
		$elem = $(this).find('.service-group')
		$('#navSpacer').stop().animate { height: $elem.outerHeight(true) }, 500
		return
	), ->
		# $elem = $(this).find('.service-group')
		$('#navSpacer').finish().animate { height: 0 }, 500
		return

	# $('.nav-hover a').hover (->
	# 	$( $(this).data('target') ).collapse 'show', ->
	# 		$('#navDropdowns .collapse').collapse 'hide'
	# 		return
	# 	return
	# ), ->
	# 	$('#navDropdowns .collapse').collapse 'hide'
	# 	return

	# 4a affix
	$(window).on 'load resize', ->
		if $(this).width() > 752
			$(this).on '.affix'
			$('#hc-4a-left-nav').width $('#hc-4a-left-nav-container').width()
			$('#hc-4a-left-nav-container').height $('#hc-4a-left-nav-container').parent().height()
			$('#hc-4a-left-nav').affix offset:
				top: ->
					@top = $('#hc-main-nav').outerHeight(true) + $('#hc-4a-header').outerHeight(true)
				bottom: ->
					@bottom = $('#hc-footer').outerHeight(true) + 15
		else
			$(this).off '.affix'
			$('#hc-4a-left-nav').removeData('affix').removeClass 'affix affix-top affix-bottom'
			$('#hc-4a-left-nav').width 'auto'
			$('#hc-4a-left-nav-container').height 'auto'
		return
