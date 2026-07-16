extends ArrowModule

@export var shape: Shape2D
@export var projectile_scene: PackedScene

@export var explosion_sfx: AD_AudioEffect

@onready var collision: CollisionShape2D

func _ready() -> void:
	collision = CollisionShape2D.new()
	collision.shape = shape
	
	add_child.call_deferred(collision)
	

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"): return
	
	var sfx_player := AD_SfxPlayer.new()
	sfx_player.effect = explosion_sfx
	get_tree().root.add_child(sfx_player)
	
	var p1 := projectile_scene.instantiate() as ProjectileBase
	var p2 := projectile_scene.instantiate() as ProjectileBase
	var p3 := projectile_scene.instantiate() as ProjectileBase
	var p4 := projectile_scene.instantiate() as ProjectileBase
	
	p1.global_position = arrow_root.global_position
	p2.global_position = arrow_root.global_position
	p3.global_position = arrow_root.global_position
	p4.global_position = arrow_root.global_position
	
	p1.direction = Vector2(0, -1)
	p2.direction = Vector2(-1, 0)
	p3.direction = Vector2(0, 1)
	p4.direction = Vector2(1, 0)
	
	AD_ArrowSpawner.singleton.arrow_holder.add_child.call_deferred(p1)
	AD_ArrowSpawner.singleton.arrow_holder.add_child.call_deferred(p2)
	AD_ArrowSpawner.singleton.arrow_holder.add_child.call_deferred(p3)
	AD_ArrowSpawner.singleton.arrow_holder.add_child.call_deferred(p4)
	
	arrow_root.queue_free()
	
