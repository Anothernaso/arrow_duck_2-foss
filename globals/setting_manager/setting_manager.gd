class_name AD_SettingManager
extends Node

@export var _registry: AD_SettingRegistry

@onready var _runtime_generator: AD_SettingsManager_RuntimeGenerator = $RuntimeGenerator

var _rt_settings: Dictionary[StringName, AD_RuntimeSetting]
var _config_file: ConfigFile

const _SECTION: String = "settings"

func _ready() -> void:
	_rt_settings = _runtime_generator.generate_runtime_settings(_registry)
	

## Opens the config file so that changes can be made.
func open() -> void:
	if _config_file:
		return
		
	
	_config_file = ConfigFile.new()
	
	if FileAccess.file_exists(AD_Constants.SETTINGS_FILE_PATH):
		_config_file.load(AD_Constants.SETTINGS_FILE_PATH)
		
	

## Closes the config file, discarding any unsaved changes.
func discard() -> void:
	if !_config_file:
		return
		
	
	_config_file = null
	

## Saves the config file, applies all changes and closes the config file.
func apply() -> void:
	if !_config_file:
		return
		
	
	_config_file.save(AD_Constants.SETTINGS_FILE_PATH)
	
	for name_: StringName in _rt_settings.keys():
		var rt_setting := _rt_settings[name]
		
		if !rt_setting.has_changed:
			return
			
		
		for listener in rt_setting.listeners:
			listener.call(_config_file.get_value(_SECTION, name_))
			
		
	
	_config_file = null
	

## Reads a setting,
## returning null if the config file is not open,
## or if no setting with the given name exists.
func read(name_p: StringName) -> Variant:
	if !_config_file:
		return null
		
	
	if !_rt_settings.has(name_p):
		return null
		
	
	var rt_setting := _rt_settings[name_p]
	
	return _config_file.get_value(_SECTION, name_p, rt_setting.setting.default_value)
	

## Resets the setting with the given name
func reset(name_p: StringName) -> void:
	if !_config_file:
		return
		
	
	if !_rt_settings.has(name_p):
		return
		
	
	var rt_setting := _rt_settings[name_p]
	
	if _config_file.has_section_key(_SECTION, name_p):
		_config_file.erase_section_key(_SECTION, name_p)
		
	
	rt_setting.has_changed = true
	

func write(name_p: StringName, value: Variant) -> void:
	pass # TODO: Implement
	
