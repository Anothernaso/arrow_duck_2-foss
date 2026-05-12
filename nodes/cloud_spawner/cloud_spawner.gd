class_name AD_CloudSpawner
extends Node2D

static var singleton: AD_CloudSpawner

@export var cloud_registry: CloudRegistry
@export var min_spawn_point: Node2D
@export var max_spawn_point: Node2D

@onready var cloud_holder: Node2D = $CloudHolder

func _ready() -> void:
	singleton = self
	_initialize.call_deferred()
	

func _initialize() -> void:
	AD_TimeTicker.singleton.on_tick.connect(_on_tick)

func _on_tick(_delta: float) -> void:
	var success := randf() < 0.2
	
	if !success || cloud_registry.cloud_scenes.is_empty(): return
	
	var cloud_scene := AD_ArrayUtils \
		.get_random_element(
			cloud_registry.cloud_scenes
		) as PackedScene
	
	var cloud := cloud_scene.instantiate() as CloudBase
	var spawn_position := AD_Vector2Utils.randv2_range(
		min_spawn_point.global_position,
		max_spawn_point.global_position
	)
	
	cloud.global_position = spawn_position
	cloud_holder.add_child(cloud)
	
