---
---

$ ->

	# force footer to bottom
	$(document).ready ->
		contentHeight = $(window).height()
		footerHeight = $('#hc-footer').innerHeight()
		footerTop = $('#hc-footer').position().top + footerHeight
		if footerTop < contentHeight
			$('#hc-footer').css 'margin-top', contentHeight - footerTop + 'px'
		return

	# nav spacer animation
	$('#hc-main-nav-sections > li').hover (->
		$elem = $(this).find('.hc-nav-dropdown')
		$('#navSpacer').stop().animate { height: $elem.outerHeight(true) }, 500 unless $('#hc-main-nav-collapse').hasClass('in')
		return
	), ->
		$('#navSpacer').finish().animate { height: 0 }, 500
		return

	# affix template
	$(window).on 'load resize', ->
		if $(this).width() > 752
			$(this).on '.affix'
			$('#hc-affix-left-nav').width $('#hc-affix-left-nav-container').width()
			$('#hc-affix-left-nav-container').height $('#hc-affix-left-nav-container').parent().height()
			$('#hc-affix-left-nav').affix offset:
				top: ->
					@top = $('#hc-main-nav').outerHeight(true) + $('#hc-affix-header').outerHeight(true)
				bottom: ->
					@bottom = $('#hc-footer').outerHeight(true)
		else
			$(this).off '.affix'
			$('#hc-affix-left-nav').removeData('affix').removeClass 'affix affix-top affix-bottom'
			$('#hc-affix-left-nav').width 'auto'
			$('#hc-affix-left-nav-container').height 'auto'
		return
