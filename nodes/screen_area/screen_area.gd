extends Area2D

func _ready() -> void:
	var collision := CollisionShape2D.new()
	
	var shape := RectangleShape2D.new()
	shape.size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width") as float,
		ProjectSettings.get_setting("display/window/size/viewport_height") as float,
	)
	
	collision.shape = shape
	
	add_child(collision)
	

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("kill_offscreen"):
		body.queue_free()
