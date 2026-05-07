extends Node

class_name Game

@export var album: MusicAlbum

func _ready() -> void:
	var music_manager: AD_MusicManager = AD_GlobalMusicManager
	music_manager.set_album(album, true)
