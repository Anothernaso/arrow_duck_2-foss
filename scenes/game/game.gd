extends Node

class_name Game

@export var album: MusicAlbum

func _ready() -> void:
	MusicManager.set_album(album, true)
