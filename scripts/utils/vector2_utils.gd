class_name Vector2Utils

## Returns a random floating-point value between `from` and `to` (inclusive).
static func randv2_range(from: Vector2, to: Vector2) -> Vector2:
	return Vector2(
		randf_range(from.x, to.x),
		randf_range(from.y, to.y)
	)
	
