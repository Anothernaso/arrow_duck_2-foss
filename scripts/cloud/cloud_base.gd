class_name CloudBase
extends CharacterBody2D

@export var min_speed: float = 150
@export var max_speed: float = 600

@export var min_scale: float = 0.2
@export var max_scale: float = 0.8

@onready var speed: float

func _ready() -> void:
	scale = Vector2Utils.randv2_range(
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
	if global_position.x < CloudSpawner.singleton.min_despawn_point.global_position.x:
		queue_free()
	
	velocity.x = -speed
	velocity.y = 0
	
	move_and_slide()
	
