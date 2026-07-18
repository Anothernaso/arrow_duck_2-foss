class_name AD_CloudBase
extends CharacterBody2D

@export var min_speed: float = 150
@export var max_speed: float = 600

@export var min_scale: float = 0.2
@export var max_scale: float = 0.8

@onready var speed: float


func _ready() -> void:
	add_to_group("cloud")
	add_to_group("kill_offscreen")
	
	# Add the body to the `kill_offscreen` layer
	set_collision_layer_value(3, true)
	
	scale = AD_Vector2Utils.randv2_range(
		Vector2(
			min_scale,
			min_scale
		),
		Vector2(
			max_scale,
			max_scale
		)
	)
	
	speed = randf_range(min_speed, max_speed)
	

func _physics_process(_delta: float) -> void:
	velocity.x = -speed
	velocity.y = 0
	
	move_and_slide()
	
