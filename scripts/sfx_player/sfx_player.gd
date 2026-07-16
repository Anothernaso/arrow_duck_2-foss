class_name AD_SfxPlayer
extends AudioStreamPlayer

@export var effect: AD_AudioEffect

func _ready() -> void:
	finished.connect(_on_finished)
	
	stream = effect.variants.pick_random()
	
	AD_GlobalSettingManager.open_config()
	volume_db = effect.volume_db + (AD_GlobalSettingManager.get_value("/audio/sfx_volume_db") as float)
	
	play()
	

func _on_finished() -> void:
	queue_free()
