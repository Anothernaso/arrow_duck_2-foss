class_name AD_FormatUtils

## Fancy time formatter that produces readable timestamps
static func format_time(seconds: float) -> String:
	var total_seconds := roundi(seconds) # Round it properly or something; IDK
	
	var hours := int(float(total_seconds) / 3600)
	var minutes := int(float(total_seconds % 3600) / 60)
	var remaining_seconds := total_seconds % 60

	var time_str := ""
	
	if hours > 0:
		time_str += str(hours) + "h "
	
	time_str += str(minutes).pad_zeros(2) + "m "
	time_str += str(remaining_seconds).pad_zeros(2) + "s"
	
	return time_str.strip_edges() # Remove any trailing spaces
