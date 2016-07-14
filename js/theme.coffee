---
---

$ ->

	# css media query breakpoint variables
	screen_is_xs = -> $('#resposnive-utility > #ru-xs').is(':visible')
	screen_is_sm = -> $('#resposnive-utility > #ru-sm').is(':visible')
	screen_is_md = -> $('#resposnive-utility > #ru-md').is(':visible')
	screen_is_lg = -> $('#resposnive-utility > #ru-lg').is(':visible')

	# pull mobile navbar to top
	pull_mobile_nav_to_top = ->
		$('#hc-main-nav-collapse').css top: -$('#hc-main-nav').offset().top
		return
	$(window).on 'load resize', ->
		pull_mobile_nav_to_top()
		return
	$('#hc-main-nav-collapse').on 'show.bs.collapse', ->
		pull_mobile_nav_to_top()
		return

	# close mobile nav on opaque backdrop click
	$('#hc-navbar-dim').on 'click', ->
		$('#hc-main-nav-collapse').collapse('hide')
		return

	# close all but first 0 .hc-collapse-panel on load
	$(window).on 'load', ->
		$collapsibles = $('.hc-collapse-panel .panel-collapse')
		$collapsibles.slice(0).collapse 'hide' if screen_is_xs()
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
		unless screen_is_xs()
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
