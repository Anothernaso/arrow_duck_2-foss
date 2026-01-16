extends ArrowModule

@export var shape: Shape2D
@onready var collision: CollisionShape2D

func _ready() -> void:
	collision = CollisionShape2D.new()
	collision.shape = shape
	
	add_child.call_deferred(collision)
	

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"): return
	
	#TODO: Spawn projectiles
	
	arrow_root.queue_free()
	
