---
---

$ ->

	calendar = new HcCalendar()

	# filter by calendar
	$('.calendar-calendar-filter').blur ->
		calendar = new HcCalendar()

	# previous and next month navigation
	$('.calendar-nav').click ->
		calendar.navigate $(this).data('calendar-nav')

#
class window.HcCalendar
	constructor: () ->
		@activeCalendars = @getActiveCalendars()
		return $('#calendar').calendar @params()

	params: ->
		tmpl_path: "{{ '/calendar/templates/' | relative_url }}"
		events_source: @getEventsSource()
		onBeforeEventsLoad: @onBeforeEventsLoad()
		onAfterEventsLoad: @onAfterEventsLoad()
		weekbox: false
		views: @setViews()
		day: @getDay()

	onBeforeEventsLoad: ->
		(next) ->
			calendar = this
			next()

	onAfterEventsLoad: ->
		(events) ->
			# console.log events
			calendar = this

			# set title
			$('#active-month').text calendar.getTitle()

			# set active month
			start_date = [calendar.options.position.start.getFullYear(), calendar.options.position.start.getMonthFormatted(), "01"].join('-')
			$('#active-month').data('start-time', start_date)

	setViews: ->
		{
			year: { enable: 0 },
			month: {
				enable: 1,
				slide_events: 1
			},
			week: { enable: 0 },
			day: { enable: 0 }
		}

	getDay: ->
		start_time = $('#active-month').data('start-time')
		if start_time
			return start_time
		else
			return 'now'

	getEventsSource: ->
		# url = "/calendar/getevents"
		url = "{{ '/calendar/events.json' | relative_url }}"

		# active calendars
		activeCalendars = $.map @activeCalendars, (ac, i) ->
			return 'Calendars[]='+ac

		# active locations
		activeLocations = []
		# $('.calendar-location-filter.active').each ->
		# 	activeLocations.push "Locations[]=" + $(this).data('value')
		# 	return

		url = url + '?' + [activeCalendars.join('&'), activeLocations.join('&')].join('&')
		# console.log url

		return url

	getActiveCalendars: ->
		activeCalendars = []
		$('.calendar-calendar-filter.active').each ->
			activeCalendars.push $(this).data('value')
			return
		return activeCalendars
