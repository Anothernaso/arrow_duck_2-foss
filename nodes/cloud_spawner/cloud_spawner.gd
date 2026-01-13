class_name CloudSpawner
extends Node2D

func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	TimeTicker.singleton.on_tick.connect(_on_tick)

# TODO: Finish implementing

func _on_tick(_delta: float) -> void:
	var success := randf() < 0.2
	
	if !success: return
	
	
	
