extends StaticBody2D

func _make_border(normal: Vector2) -> CollisionShape2D:
	var border := CollisionShape2D.new()
	
	var shape := WorldBoundaryShape2D.new()
	shape.normal = normal
	
	border.shape = shape
	
	return border
	

func _ready() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	
	var width_quarter := float(vp_size.x) / 4
	var height_half := float(vp_size.y) / 2
	
	# North border
	var n := _make_border(Vector2(0, 1))
	n.global_position.y = -height_half
	
	# West border
	var w := _make_border(Vector2(1, 0))
	w.global_position.x = -width_quarter
	
	# South border
	var s := _make_border(Vector2(0, -1))
	s.global_position.y = height_half
	
	# East border
	var e := _make_border(Vector2(-1, 0))
	e.global_position.x = width_quarter
	
	
	add_child(n)
	add_child(w)
	add_child(s)
	add_child(e)
	
