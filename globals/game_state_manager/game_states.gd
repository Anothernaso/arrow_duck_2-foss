class_name AD_GameStates
extends Resource

@export var default_state: State
@export var state_scenes: Dictionary[State, PackedScene]

enum State {
	MAIN_MENU,
	IN_GAME,
	DEATH_SCREEN,
}
