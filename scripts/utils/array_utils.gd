class_name ArrayUtils

# Small utility function that returns a random element from an array
static func get_random_element(array: Array) -> Variant:
	if array.size() == 0:
		return null
	return array[randi() % array.size()]
