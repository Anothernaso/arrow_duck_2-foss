# A singleton Node that lives in the Root scene.
# It continuously plays random tracks from a MusicRegistry.

class_name Music
extends Node

static var singleton: Music

var music_registry: MusicRegistry

func _ready() -> void:
	singleton = self
	print("There should be music!")

func play_random() -> void:
	var clip = ArrayUtils.get_random_element(music_registry.music_streams)
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = clip
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished() -> void:
	play_random()
