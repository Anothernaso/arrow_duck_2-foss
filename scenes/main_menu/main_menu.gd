extends Node


class_name MainMenu

@export var album: MusicAlbum

func _ready() -> void:
	MusicManager.set_album(album)
	

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_start_button_down() -> void:
	GameStateManager.set_state(GameStates.State.InGame)

func _on_delete_data_button_down() -> void:
	SaverUtils.delete(Constants.PERSISTENT_DIR, Constants.CURRENT_TIMELINE_FILE_NAME)
	SaverUtils.delete(Constants.PERSISTENT_DIR, Constants.HIGHSCORE_FILE_NAME)
