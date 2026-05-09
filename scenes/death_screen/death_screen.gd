extends Node

class_name DeathScreen

@export var album: MusicAlbum

@onready var score_label: Label = $UI/Control/CenterContainer/Panel/VSplitContainer/VBoxContainer/ScoreLabel
@onready var highscore_label: Label = $UI/Control/CenterContainer/Panel/VSplitContainer/VBoxContainer/HighscoreLabel

func _ready() -> void:
	var music_manager: AD_MusicManager = AD_GlobalMusicManager
	music_manager.set_album(album, AD_MusicManager.ForcePlayMode.IfChanged)
	
	score_label.text = "Time Survived: " + FormatUtils.format_time(ScoreCounter.last_time_survived)
	highscore_label.text = "Highscore: " + FormatUtils.format_time(ScoreCounter.highscore_time_survived)
	

func _on_retry_button_down() -> void:
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	game_state_manager.set_state(GameStates.State.InGame)


func _on_main_menu_button_down() -> void:
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	game_state_manager.set_state(GameStates.State.MainMenu)
