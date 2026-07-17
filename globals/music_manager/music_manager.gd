class_name AD_MusicManager
extends Node

enum ForcePlayMode {
	Never,
	IfChanged,
	Always,
}

@export var _volume: float
@export var _low_volume: float
@export var _fade_time: float

@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer
var _current_album: AD_MusicAlbum

var _fading_out: bool

func _ready() -> void:
	_audio_player.volume_db = _low_volume
	

func _transition_to(stream: AudioStream) -> void:
	var fade_in :=  func() -> void:
		_audio_player.stream = stream
		_audio_player.play()
		
		AD_GlobalSettingManager.open_config()
		
		var t := create_tween()
		t.tween_property(
			_audio_player, "volume_db",
			_volume + (
				AD_GlobalSettingManager.get_value(
					"/audio/music_volume_db"
					).value as float
				),
			_fade_time
			)
			
		
	
	# Only fade out if a track is already playing
	if _audio_player.playing:
		var tween := create_tween()
		tween.tween_property(_audio_player, "volume_db", _low_volume, _fade_time)
		tween.finished.connect(fade_in)
	else:
		fade_in.call()
	

func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(_audio_player, "volume_db", _low_volume, _fade_time)
	tween.finished.connect(func() -> void:
		_audio_player.stop() # This does not trigger `finished` signal
		_fading_out = false
		
		play_random()
	)


# Fade out the current track when it is about to end
func _process(_delta: float) -> void:
	if !_audio_player.playing || _fading_out:
		return
		
	
	var length := _audio_player.stream.get_length()
	var pos := _audio_player.get_playback_position()
	
	if length - pos <= _fade_time:
		_fading_out = true
		_fade_out()
	

func play_stream(stream: AudioStream) -> void:
	print("Now playing: ", stream.resource_path)
	
	_transition_to(stream)
	

func set_album(album: AD_MusicAlbum, force_play_mode: ForcePlayMode = ForcePlayMode.Never) -> void:
	var last_album := _current_album
	_current_album = album
	
	var force_play := func () -> void:
		print("Changing album to: ", album.resource_path)
		play_random()
	
	if !_audio_player.playing:
		force_play.call()
	elif force_play_mode == ForcePlayMode.Always:
		force_play.call()
	elif force_play_mode == ForcePlayMode.IfChanged && _current_album != last_album:
		force_play.call()
		
	

func play_random() -> void:
	if !_current_album: return
	
	var stream := _current_album.streams.pick_random() as AudioStream
	play_stream(stream)
	
