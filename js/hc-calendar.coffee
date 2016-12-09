---
---

$ ->

	calendar = $('#calendar').calendar new CalendarOptions()
	# console.log calendar

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
				enable: 1,
				slide_events: 1
			},
			week: { enable: 0 },
			day: { enable: 0 }
		}

	getEventsSource: ->
		# url = "/calendar/getevents"
		url = "{{ '/calendar/events.json' | relative_url }}"

		# active calndars
		activeCalendars = []
		$('.calendar-calendar-filter.active').each ->
			activeCalendars.push "Calendars[]=" + $(this).data('value')
			return

		# active locations
		activeLocations = []
		# $('.calendar-location-filter.active').each ->
		# 	activeLocations.push "Locations[]=" + $(this).data('value')
		# 	return

		url = url + '?' + [activeCalendars.join('&'), activeLocations.join('&')].join('&')
		# console.log url

		return url
