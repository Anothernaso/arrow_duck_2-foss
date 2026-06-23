class_name AD_PauseManager
extends Node

signal state_changed(new_state: PauseState)

static var singleton: AD_PauseManager

var _state: PauseState = PauseState.RUNNING

enum PauseState {
	RUNNING,
	PAUSED,
}

func _ready() -> void:
	singleton = self
	

func _exit_tree() -> void:
	# Always unpause when freed
	get_tree().paused = false
	

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("game_pause"):
		toggle_state()
		
	

func set_state(state: PauseState) -> void:
	_state = state
	
	var tree := get_tree()
	
	match state:
		PauseState.RUNNING:
			tree.paused = false
			state_changed.emit(state) # Emit the signal after unpausing
		PauseState.PAUSED:
			state_changed.emit(state) # Emit the signal before pausing
			tree.paused = true
			
		
	

func toggle_state() -> void:
	match _state:
		PauseState.RUNNING:
			set_state(PauseState.PAUSED)
		PauseState.PAUSED:
			set_state(PauseState.RUNNING)
			
		
	
