extends Node


class_name MainMenu

@export var album: MusicAlbum

func _ready() -> void:
	var music_manager: AD_MusicManager = AD_GlobalMusicManager
	music_manager.set_album(album, AD_MusicManager.ForcePlayMode.IfChanged)
	

func _on_start_button_down() -> void:
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	game_state_manager.set_state(GameStates.State.InGame)

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_delete_data_button_down() -> void:
	print("Deleting all saved data!")
	SaverUtils.delete(Constants.PERSISTENT_DIR, Constants.CURRENT_TIMELINE_FILE_NAME)
	SaverUtils.delete(Constants.PERSISTENT_DIR, Constants.HIGHSCORE_FILE_NAME)
