---
---

$ ->

	# nav spacer animation
	$('#hc-main-nav-sections li').hover (->
		$elem = $(this).find('.hc-nav-dropdown')
		$('#navSpacer').stop().animate { height: $elem.outerHeight(true) }, 500 unless $('#hc-main-nav-collapse').hasClass('in')
		return
	), ->
		$('#navSpacer').finish().animate { height: 0 }, 500
		return

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
