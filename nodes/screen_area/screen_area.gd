extends Area2D

func _ready() -> void:
	var collision := CollisionShape2D.new()
	
	var shape := RectangleShape2D.new()
	
	var vp_size := get_viewport().get_visible_rect().size
	shape.size = Vector2(
		vp_size.x,
		vp_size.y,
	)
	
	collision.shape = shape
	
	add_child(collision)
	

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("kill_offscreen"):
		body.queue_free()
		
	
