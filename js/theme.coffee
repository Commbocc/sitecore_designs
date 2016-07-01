---
---

# css media query breakpoint variables
screen_xs_max = 752						# screen_xs_max = 767
screen_sm_max = 976						# screen_sm_max = 991
screen_lg_min = 1185						# screen_lg_min = 1200
screen_sm_min = screen_sm_min + 1	# screen_sm_min = 768
screen_md_min = screen_sm_max + 1	# screen_md_min = 992
screen_md_max = screen_lg_min - 1	# screen_md_max = 1199

$ ->

	# close all but first 0 .hc-collapse-panel on load
	$(window).on 'load', ->
		$collapsibles = $('.hc-collapse-panel .panel-collapse')
		$collapsibles.slice(0).collapse 'hide' unless $(this).width() > screen_xs_max
		return

	# force footer to bottom
	$(document).ready ->
		contentHeight = $(window).height()
		footerHeight = $('#hc-footer').innerHeight()
		footerTop = $('#hc-footer').position().top + footerHeight
		$('#hc-footer').css 'margin-top', contentHeight - footerTop + 'px' if footerTop < contentHeight
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
		if $(this).width() > screen_xs_max
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
