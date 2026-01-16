class_name ProjectileBase
extends CharacterBody2D

@export var speed: float = 300

@export var shape: Shape2D
@export var texture: Texture

@onready var collider: CollisionShape2D
@onready var sprite: Sprite2D

var direction: Vector2

func _ready() -> void:
	if !is_in_group("projectile"): add_to_group("projectile")
	if !is_in_group("lethal"): add_to_group("lethal")
	
	collider = CollisionShape2D.new()
	sprite = Sprite2D.new()
	
	collider.shape = shape
	sprite.texture = texture
	
	add_child.call_deferred(collider)
	add_child.call_deferred(sprite)
	

func _physics_process(_delta: float) -> void:
	velocity = direction.normalized() * speed
	move_and_slide()
	
