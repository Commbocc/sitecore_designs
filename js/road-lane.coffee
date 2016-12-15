---
---

window.parseGoogleSheet = (json) ->
	raw_cells = json.feed.entry

	rows = _.groupBy _.map(raw_cells, (c) -> return c['gs$cell'] ), (c) ->
		return c.row

	$.each rows, (i, row_cells) ->
		is_head_row = if (i.toString() == "1") then true else false

		$row = $('<tr>')
		$.each row_cells, (ci, cell) ->
			$cell = if is_head_row then $('<th>') else $('<td>')
			$cell.text cell['$t']
			$row.append $cell
			return

		table_section = if is_head_row then 'thead' else 'tbody'

		$('#road-lane-closures table '+table_section).append $row
		return

	return
