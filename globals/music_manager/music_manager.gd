extends Node

@export var _volume: float
@export var _fade_time: float

@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer
var _current_album: MusicAlbum

func _ready() -> void:
	_audio_player.volume_db = _volume
	

func _transition_to(stream: AudioStream):
	var tween := create_tween()
	tween.tween_property(_audio_player, "volume_db", -80, _fade_time)

	tween.finished.connect(func():
		_audio_player.stream = stream
		_audio_player.play()

		var fade_in := create_tween()
		fade_in.tween_property(_audio_player, "volume_db", _volume, _fade_time)
	)

func play_stream(stream: AudioStream) -> void:
	print("Now playing: ", stream.resource_path)
	
	_transition_to(stream)
	

func set_album(album: MusicAlbum, force_play: bool = false) -> void:
	print("Changing album to: ", album.resource_path)
	
	_current_album = album
	
	if !_audio_player.playing || force_play:
		play_random()
		
	

func play_random() -> void:
	if !_current_album: return
	
	var stream := ArrayUtils.get_random_element(_current_album.streams) as AudioStream
	play_stream(stream)
	

func _on_audio_stream_player_finished() -> void:
	play_random()
	
