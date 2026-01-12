extends Node

class_name DeathScreen

@export var music: MusicRegistry

func _ready() -> void:
	if Music.singleton.music_registry != music:
		Music.singleton.music_registry = music
		Music.singleton.play_random()
	
	$UI/Control/Panel/Score.text = "Time survived: " + FormatUtils.format_time(ScoreCounter.last_time_survived)
	$UI/Control/Panel/Highscore.text = "Highscore: " + FormatUtils.format_time(ScoreCounter.highscore_time_survived)
	

func _on_try_again_button_down() -> void:
	Root.singleton.enter_game.call_deferred()


func _on_main_menu_button_button_down() -> void:
	Root.singleton.enter_main_menu.call_deferred()
