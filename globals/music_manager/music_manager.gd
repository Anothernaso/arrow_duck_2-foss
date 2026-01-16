extends Node

@export var _volume: float
@export var _low_volume: float
@export var _fade_time: float

@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer
var _current_album: MusicAlbum

var fading_out: bool

func _ready() -> void:
	_audio_player.volume_db = _low_volume
	

func _transition_to(stream: AudioStream):
	var fade_in :=  func():
		_audio_player.stream = stream
		_audio_player.play()

		var t := create_tween()
		t.tween_property(_audio_player, "volume_db", _volume, _fade_time)
		
	
	# Only fade out if a track is already playing
	if _audio_player.playing:
		var tween := create_tween()
		tween.tween_property(_audio_player, "volume_db", _low_volume, _fade_time)
		tween.finished.connect(fade_in)
	else:
		fade_in.call()
	

func _fade_out():
	var tween := create_tween()
	tween.tween_property(_audio_player, "volume_db", _low_volume, _fade_time)
	tween.finished.connect(func():
		_audio_player.stop()
		fading_out = false
	)


# Fade out the current track when it is about to end
func _process(_delta):
	if !_audio_player.playing || fading_out:
		return
		
	
	var length := _audio_player.stream.get_length()
	var pos := _audio_player.get_playback_position()
	
	if length - pos <= _fade_time:
		fading_out = true
		_fade_out()
	

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
	
