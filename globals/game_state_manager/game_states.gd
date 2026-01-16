class_name GameStates
extends Resource

@export var default_state: State
@export var state_scenes: Dictionary[State, PackedScene]

enum State {
	MainMenu,
	InGame,
	DeathScreen,
}
