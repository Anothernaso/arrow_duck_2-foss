class_name AD_CloudSpawner
extends Node2D

static var singleton: AD_CloudSpawner

@export var _cloud_registry: AD_CloudRegistry

@onready var _min_spawn_point: Vector2
@onready var _max_spawn_point: Vector2

@onready var _cloud_holder: Node2D = $CloudHolder

func _ready() -> void:
	singleton = self
	
	var vp_size := get_viewport().get_visible_rect().size
	var vp_half :=  vp_size / 2
	
	var north := -vp_half.y
	var east  := vp_half.x
	var south := vp_half.y
	
	# Multiply it by two so that coulds spawn beyond the edge of the viewport
	var x_pos := east * 2
	
	_min_spawn_point = Vector2(x_pos, north)
	_max_spawn_point = Vector2(x_pos, south)
	
	_initialize.call_deferred()
	

func _initialize() -> void:
	AD_TimeTicker.singleton.on_tick.connect(_on_tick)
	

func _on_tick(_delta: float) -> void:
	var success := randf() < 0.2
	
	if !success || _cloud_registry.cloud_scenes.is_empty(): return
	
	var cloud_scene: PackedScene = _cloud_registry.cloud_scenes.pick_random()
	
	var cloud := cloud_scene.instantiate() as AD_CloudBase
	var spawn_position := AD_Vector2Utils.randv2_range(
		_min_spawn_point,
		_max_spawn_point,
	)
	
	cloud.global_position = spawn_position
	_cloud_holder.add_child(cloud)
	
