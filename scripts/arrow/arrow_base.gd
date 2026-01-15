class_name ArrowBase
extends CharacterBody2D

@export var speed: float = 300

@export var shape: Shape2D
@export var texture: Texture

@onready var has_enpooled: bool

@onready var collider: CollisionShape2D
@onready var sprite: Sprite2D

func _enter_tree() -> void:
	has_enpooled = false
	
	collider = CollisionShape2D.new()
	sprite = Sprite2D.new()
	
	collider.shape = shape
	sprite.texture = texture
	
	add_child.call_deferred(collider)
	add_child.call_deferred(sprite)
	

func _exit_tree() -> void:
	if collider:
		collider.free()
	if sprite:
		sprite.free()
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE && Pooler.singleton:
		Pooler.singleton.report_free(self)
		
	

func _physics_process(_delta: float) -> void:
	if global_position.x < ArrowSpawner.min_destruction_point.x && !has_enpooled:
		has_enpooled = true
		Pooler.singleton.enpool_node(self)
	
	velocity.x = -speed
	velocity.y = 0
	
	move_and_slide()
	
