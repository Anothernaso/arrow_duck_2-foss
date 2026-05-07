class_name ArrowBase
extends CharacterBody2D

@export var speed: float = 300

@export var shape: Shape2D
@export var texture: Texture

@onready var collider: CollisionShape2D
@onready var sprite: Sprite2D

func _ready() -> void:
	add_to_group("arrow")
	add_to_group("lethal")
	add_to_group("kill_offscreen")
	
	# Add the body to the `kill_offscreen` layer
	set_collision_layer_value(3, true)
	
	collider = CollisionShape2D.new()
	sprite = Sprite2D.new()
	
	collider.shape = shape
	sprite.texture = texture
	
	add_child.call_deferred(collider)
	add_child.call_deferred(sprite)
	

func _physics_process(_delta: float) -> void:
	velocity.x = -speed
	velocity.y = 0
	
	move_and_slide()
	
