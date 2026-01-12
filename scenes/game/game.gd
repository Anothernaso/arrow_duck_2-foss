extends Node

class_name Game

@export var music: MusicRegistry

func _ready() -> void:
	if Music.singleton.music_registry != music:
		Music.singleton.music_registry = music
		Music.singleton.play_random()
