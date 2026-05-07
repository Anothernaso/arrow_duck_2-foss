extends Node

class_name DeathScreen

@export var album: MusicAlbum

@onready var score_counter_label: Label = $UI/Control/Panel/ScoreCounter
@onready var highscore_counter_label: Label = $UI/Control/Panel/HighscoreCounter

func _ready() -> void:
	var music_manager: AD_MusicManager = AD_GlobalMusicManager
	music_manager.set_album(album, true)
	
	score_counter_label.text = "Time survived: " + FormatUtils.format_time(ScoreCounter.last_time_survived)
	highscore_counter_label.text = "Highscore: " + FormatUtils.format_time(ScoreCounter.highscore_time_survived)
	

func _on_try_again_button_down() -> void:
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	game_state_manager.set_state(GameStates.State.InGame)


func _on_main_menu_button_button_down() -> void:
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	game_state_manager.set_state(GameStates.State.MainMenu)
