class_name ArrowBase
extends CharacterBody2D

@export var speed: float = 300

@export var shape: Shape2D
@export var texture: Texture

var collider: CollisionShape2D
var sprite: Sprite2D

func _ready() -> void:
	collider = CollisionShape2D.new()
	sprite = Sprite2D.new()
	
	collider.shape = shape
	sprite.texture = texture
	
	add_child.call_deferred(collider)
	add_child.call_deferred(sprite)
	

func _physics_process(_delta: float) -> void:
	if global_position.x < ArrowSpawner.min_destruction_point.x:
		queue_free()
	
	velocity.x = -speed
	velocity.y = 0
	
	move_and_slide()
	
