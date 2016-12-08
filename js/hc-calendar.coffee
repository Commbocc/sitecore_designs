---
---

$ ->

	calendar = $('#calendar').calendar new CalendarOptions()

	# previous and next month navigation
	$('.calendar-nav').click ->
		calendar.navigate $(this).data('calendar-nav')

	# filter by calendar
	$('.calendar-calendar-filter').blur ->
		newCalOptions = new CalendarOptions()
		calendar.setOptions events_source: newCalOptions.events_source
		calendar.view()

#
class window.CalendarOptions
	constructor: () ->
		@tmpl_path = "{{ '/calendar/templates/' | relative_url }}"
		@events_source = @getEventsSource()
		@onBeforeEventsLoad = @onBeforeEventsLoad()
		@onAfterEventsLoad = @onAfterEventsLoad()
		@weekbox = false
		@views = @setViews()

	onBeforeEventsLoad: ->
		that = @
		(next) ->
			calendar = this

			next()

	onAfterEventsLoad: ->
		that = @
		(events) ->
			calendar = this

			# set title
			$('#active-month').text calendar.getTitle()

	setViews: ->
		{
			year: { enable: 0 },
			month: {
				slide_events: 1,
				enable: 1
			},
			week: { enable: 0 },
			day: { enable: 0 }
		}

	getEventsSource: (params = {}) ->
		url = "{{ '/calendar/events.json' | relative_url }}"
		# url = "http://hcflgov.net/calendar/getevents"

		# calndars
		activeCalendars = []
		$('.calendar-calendar-filter.active').each ->
			activeCalendars.push "Calendars[]=" + $(this).data('value')
			return
		calendars = activeCalendars.join('&')

		# locations
		activeLocations = []
		locations = activeLocations.join('&')

		url = url + '?' + [calendars, locations].join('&')
		return url
