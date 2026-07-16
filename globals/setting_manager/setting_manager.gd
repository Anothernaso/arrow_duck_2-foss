class_name AD_SettingManager
extends Node

@export var _setting_registry: AD_SettingRegistry

@onready var _runtime_generator: AD_SettingsManager_RuntimeGenerator = $RuntimeGenerator

var _settings: Dictionary[StringName, AD_RuntimeSetting]
var _config_file: ConfigFile

func _ready() -> void:
	_settings = _runtime_generator.generate_runtime_settings(_setting_registry)
	
