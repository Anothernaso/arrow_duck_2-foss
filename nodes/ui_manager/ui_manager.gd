class_name AD_UIManager
extends Node

static var singleton: AD_UIManager

@export var _hud_scene: PackedScene
@export var _pause_menu_scene: PackedScene

var _state: UIState = UIState.HUD
var _ui_node: Node

enum UIState {
	HUD,
	PAUSE_MENU,
}

func _ready() -> void:
	singleton = self
	_update_ui()
	
	# Connect signal on next frame
	(func() -> void:
		AD_PauseManager.singleton.state_changed.connect(_on_pause_state_changed)
	).call_deferred()

## Called when `AD_PauseManager` changes its state,
## updating the UI accordingly.
func _on_pause_state_changed(new_state: AD_PauseManager.PauseState) -> void:
	match new_state:
		AD_PauseManager.PauseState.RUNNING:
			set_state(UIState.HUD)
		AD_PauseManager.PauseState.PAUSED:
			set_state(UIState.PAUSE_MENU)
			
		
	

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
			
		
		UIState.PAUSE_MENU:
			quick_spawn.call(_pause_menu_scene)
			
		
	

func set_state(state: UIState) -> void:
	_state = state
	_update_ui()
	
