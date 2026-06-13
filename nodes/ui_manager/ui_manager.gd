class_name AD_UIManager
extends Node

static var singleton: AD_UIManager

@export var _hud_scene: PackedScene

var _state: UIState = UIState.HUD
var _ui_node: Node

enum UIState {
	HUD,
	PauseMenu,
}

func _ready() -> void:
	singleton = self
	_update_ui()
	

func _update_ui() -> void:
	if _ui_node:
		_ui_node.queue_free()
		
	
	var quick_spawn := func (scene: PackedScene) -> void:
		var node := scene.instantiate()
		_ui_node = node
		add_child.call_deferred(node)
		
	
	match _state:
		UIState.HUD:
			quick_spawn.call(_hud_scene)
			
		
		UIState.PauseMenu:
			#quick_spawn.call(_pause_menu_scene)
			pass
			
		
	

func set_state(state: UIState) -> void:
	_state = state
	_update_ui()
	
