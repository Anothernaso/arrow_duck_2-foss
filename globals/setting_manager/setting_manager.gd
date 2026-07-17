class_name AD_SettingManager
extends Node

@export var _registry: AD_SettingRegistry

@onready var _runtime_generator: AD_SettingsManager_RuntimeGenerator = $RuntimeGenerator

var _rt_settings: Dictionary[StringName, AD_RuntimeSetting]
var _config_file: ConfigFile

const _SECTION: String = "settings"

enum SettingManagerError {
	OK = 0,
	LOAD_CONFIG_ERROR = 1,
	SAVE_CONFIG_ERROR = 2,
	CONFIG_NOT_LOADED = 4,
	NO_SUCH_SETTING = 5,
	VARIANT_TYPE_MISMATCH = 6,
}

var _load_config_error: Error
var load_config_error: Error:
	get():
		return _load_config_error
		
	

var _save_config_error: Error
var save_config_error: Error:
	get():
		return _save_config_error
		
	

func _ready() -> void:
	_rt_settings = _runtime_generator.generate_runtime_settings(_registry)
	

## Opens the config file so that changes can be made.
func open_config() -> SettingManagerError:
	var error: Error
	
	if _config_file:
		return SettingManagerError.OK
		
	
	_config_file = ConfigFile.new()
	
	if FileAccess.file_exists(AD_Constants.SETTINGS_FILE_PATH):
		error = _config_file.load(AD_Constants.SETTINGS_FILE_PATH)
		
		if error:
			_load_config_error = error
			
			push_error("`ConfigFile.load` error: ", error)
			
			return SettingManagerError.LOAD_CONFIG_ERROR
			
		
	
	return SettingManagerError.OK
	

## Closes the config file, discarding any unsaved changes.
func discard_changes() -> void:
	if !_config_file:
		return
		
	
	_config_file = null
	
	# Reset the `has_changed` statuses
	for name_: StringName in _rt_settings.keys():
		var rt_setting := _rt_settings[name_]
		rt_setting.has_changed = false
		
	

## Saves the config file, applies all changes and closes the config file.
func apply_settings() -> SettingManagerError:
	var error: Error
	
	if !_config_file:
		return SettingManagerError.OK
		
	
	error = _config_file.save(AD_Constants.SETTINGS_FILE_PATH)
	if error:
		_save_config_error = error
		
		push_error("Could not apply settings: ", SettingManagerError.SAVE_CONFIG_ERROR)
		
		return SettingManagerError.SAVE_CONFIG_ERROR
		
	
	for name_: StringName in _rt_settings.keys():
		var rt_setting := _rt_settings[name]
		
		if !rt_setting.has_changed:
			continue
			
		
		var value: Variant = _config_file.get_value(_SECTION, name_, rt_setting.setting.default_value)
		
		for listener in rt_setting.listeners:
			listener.call(value)
			
		
	
	_config_file = null
	
	return SettingManagerError.OK
	

var _get_value_error: SettingManagerError
var get_value_error: SettingManagerError:
	get():
		return _get_value_error
		
	

## Reads the value of a setting,
## returning null if the config file is not open,
## or if no setting with the given name exists.
func get_value(name_p: StringName) -> AUtils_VariantPointer:
	if !_config_file:
		_get_value_error = SettingManagerError.CONFIG_NOT_LOADED
		
		push_error("Could not get value of setting `" + name_p + "`: ", SettingManagerError.CONFIG_NOT_LOADED)
		
		return null
		
	
	if !_rt_settings.has(name_p):
		_get_value_error = SettingManagerError.NO_SUCH_SETTING
		
		push_error("Could not get value of setting `" + name_p + "`: ", SettingManagerError.NO_SUCH_SETTING)
		
		return null
		
	
	var rt_setting := _rt_settings[name_p]
	
	return AUtils_VariantPointer.new(
		_config_file.get_value(_SECTION, name_p, rt_setting.setting.default_value)
		)
		
	


## Resets the value of the setting with the given name.
func reset_value(name_p: StringName) -> SettingManagerError:
	if !_config_file: 
		push_error("Could not reset value of setting `" + name_p + "`: ", SettingManagerError.CONFIG_NOT_LOADED)
		return SettingManagerError.CONFIG_NOT_LOADED
		
	
	if !_rt_settings.has(name_p):
		push_error("Could not reset value of setting `" + name_p + "`: ", SettingManagerError.NO_SUCH_SETTING)
		return SettingManagerError.NO_SUCH_SETTING
		
	
	var rt_setting := _rt_settings[name_p]
	
	if _config_file.has_section_key(_SECTION, name_p):
		_config_file.erase_section_key(_SECTION, name_p)
		
	
	rt_setting.has_changed = true
	
	return SettingManagerError.OK
	

var _has_value_error: SettingManagerError
var has_value_error: SettingManagerError:
	get():
		return _has_value_error
		
	

## Checks if the setting with the given name has a value.
func has_value(name_p: StringName) -> AUtils_VariantPointer:
	if !_config_file:
		_has_value_error = SettingManagerError.CONFIG_NOT_LOADED
		
		push_error("Could not check if setting `" + name_p + "` has a value: ", SettingManagerError.CONFIG_NOT_LOADED)
		
		return null
		
	
	if !_rt_settings.has(name_p):
		_has_value_error = SettingManagerError.NO_SUCH_SETTING
		
		push_error("Could not check if setting `" + name_p + "` has a value: ", SettingManagerError.NO_SUCH_SETTING)
		
		return null
		
	
	return AUtils_VariantPointer.new(_config_file.has_section_key(_SECTION, name_p))
	

## Writes the value of the setting with the given name.
func set_value(name_p: StringName, value: Variant) -> SettingManagerError:
	if !_config_file:
		push_error("Could not set value of setting `" + name_p + "`: ", SettingManagerError.CONFIG_NOT_LOADED)
		return SettingManagerError.CONFIG_NOT_LOADED
		
	
	if !_rt_settings.has(name_p):
		push_error("Could not set value of setting `" + name_p + "`: ", SettingManagerError.NO_SUCH_SETTING)
		return SettingManagerError.NO_SUCH_SETTING
		
	
	var rt_setting := _rt_settings[name_p]
	
	if typeof(value) != typeof(rt_setting.setting.default_value):
		push_error("Could not set value of setting `" + name_p + "`: ", SettingManagerError.VARIANT_TYPE_MISMATCH)
		return SettingManagerError.VARIANT_TYPE_MISMATCH
		
	
	_config_file.set_value(_SECTION, name_p, value)
	rt_setting.has_changed = true
	
	return SettingManagerError.OK
	

func add_listener(name_p: StringName, listener: Callable) -> SettingManagerError:
	if !_rt_settings.has(name_p):
		push_error("Could not add listener to setting `" + name_p + "`: ", SettingManagerError.NO_SUCH_SETTING)
		return SettingManagerError.NO_SUCH_SETTING
		
	
	var rt_setting := _rt_settings[name_p]
	
	rt_setting.listeners.append(listener)
	
	return SettingManagerError.OK
	

func remove_listener(name_p: StringName, listener: Callable) -> SettingManagerError:
	if !_rt_settings.has(name_p):
		push_error("Could not remove listener from setting `" + name_p + "`: ", SettingManagerError.NO_SUCH_SETTING)
		return SettingManagerError.NO_SUCH_SETTING
		
	
	var rt_setting := _rt_settings[name_p]
	
	var index := rt_setting.listeners.find(listener)
	if index == -1:
		# TODO: Maybe change this to be an error or
		# a warning.
		return SettingManagerError.OK
		
	
	rt_setting.listeners.remove_at(index)
	
	return SettingManagerError.OK
	
