extends Node

@export var _states: GameStates
@onready var _current_state: GameStates.State

func _ready() -> void:
	set_state(_states.default_state)
	

func set_state(new_state: GameStates.State) -> void:
	if !_states.state_scenes.has(new_state):
		push_error("Could not set state to '" + str(new_state) + "' because it has no scene")
		return
	
	_current_state = new_state
	get_tree().change_scene_to_packed.call_deferred(_states.state_scenes[new_state])
	

func get_state() -> GameStates.State:
	return _current_state
