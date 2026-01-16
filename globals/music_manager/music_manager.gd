extends Node

@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer
var _current_album: MusicAlbum

func play_stream(stream: AudioStream) -> void:
	print("Now playing: ", stream.resource_path)
	
	_audio_player.stream = stream
	_audio_player.play()
	

func set_album(album: MusicAlbum) -> void:
	print("Changing album to: ", album.resource_path)
	
	_current_album = album
	
	if !_audio_player.playing:
		play_random()
		
	

func play_random() -> void:
	if !_current_album: return
	
	var stream := ArrayUtils.get_random_element(_current_album.streams) as AudioStream
	
	print("Now playing: ", stream.resource_path)
	
	_audio_player.stream = stream
	_audio_player.play()
	

func _on_audio_stream_player_finished() -> void:
	play_random()
	
