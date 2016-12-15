---
---

window.parseGoogleSheet = (json) ->
	raw_cells = json.feed.entry

	rows = _.groupBy _.map(raw_cells, (c) -> return c['gs$cell'] ), (c) ->
		return c.row

	$.each rows, (i, row_cells) ->
		is_head_row = if (i.toString() == "1") then true else false
		$row = $('<tr>')

		col_i = 0
		cell_i = 0
		while col_i < row_cells.length
			cell = row_cells[col_i]
			$cell = if is_head_row then $('<th>') else $('<td>')
			$cell.text cell['$t']

			if cell_i+1 == parseInt(cell.col)
				$row.append $cell
			else
				$row.append $('<td>')
				$row.append $cell
				cell_i++

			col_i++
			cell_i++

		table_section = if is_head_row then 'thead' else 'tbody'
		$('#road-lane-closures table '+table_section).append $row
		return

	return
