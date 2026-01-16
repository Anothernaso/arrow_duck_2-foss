extends Node

class_name DeathScreen

@export var album: MusicAlbum

func _ready() -> void:
	MusicManager.set_album(album)
	
	$UI/Control/Panel/Score.text = "Time survived: " + FormatUtils.format_time(ScoreCounter.last_time_survived)
	$UI/Control/Panel/Highscore.text = "Highscore: " + FormatUtils.format_time(ScoreCounter.highscore_time_survived)
	

func _on_try_again_button_down() -> void:
	GameStateManager.set_state(GameStates.State.InGame)


func _on_main_menu_button_button_down() -> void:
	GameStateManager.set_state(GameStates.State.MainMenu)
