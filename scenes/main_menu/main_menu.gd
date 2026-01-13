extends Node


class_name MainMenu

@export var music: MusicRegistry

func _ready() -> void:
	if Music.singleton.music_registry != music:
		Music.singleton.music_registry = music
		Music.singleton.play_random()

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_start_button_down() -> void:
	Root.singleton.enter_game.call_deferred()

func _on_delete_data_button_down() -> void:
	SaverUtils.delete(Constants.PERSISTENT_DIR, Constants.CURRENT_TIMELINE_FILE_NAME)
	SaverUtils.delete(Constants.PERSISTENT_DIR, Constants.HIGHSCORE_FILE_NAME)
