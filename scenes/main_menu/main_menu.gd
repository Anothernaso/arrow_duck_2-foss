extends Node


class_name MainMenu

@export var album: AD_MusicAlbum

func _ready() -> void:
	var music_manager: AD_MusicManager = AD_GlobalMusicManager
	music_manager.set_album(album, AD_MusicManager.ForcePlayMode.IfChanged)
	

func _on_start_button_down() -> void:
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	game_state_manager.set_state(AD_GameStates.State.IN_GAME)

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_delete_data_button_down() -> void:
	print("Deleting all saved data!")
	AD_SaverUtils.delete(AD_Constants.PERSISTENT_DIR, AD_Constants.CURRENT_TIMELINE_FILE_NAME)
	AD_SaverUtils.delete(AD_Constants.PERSISTENT_DIR, AD_Constants.HIGHSCORE_FILE_NAME)
