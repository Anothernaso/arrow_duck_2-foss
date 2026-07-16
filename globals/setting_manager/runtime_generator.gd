class_name AD_SettingsManager_RuntimeGenerator
extends Node

func _register_settings(base: String, settings: Array[AD_Setting]) -> Dictionary[StringName, AD_RuntimeSetting]:
	var rt_settings: Dictionary[StringName, AD_RuntimeSetting]
	
	for setting in settings:
		var rt_setting := AD_RuntimeSetting.new()
		rt_setting.setting = setting
		
		rt_settings[base + "/" + setting.name] = rt_setting
		
	
	return rt_settings
	

func _register_category(base: String, category: AD_SettingCategory) -> Dictionary[StringName, AD_RuntimeSetting]:
	var rt_settings: Dictionary[StringName, AD_RuntimeSetting]
	
	var category_base := base + "/" + category.name
	
	rt_settings.merge(_register_settings(category_base, category.settings), true)
	rt_settings.merge(_register_categories(category_base, category.subcategories), true)
	
	return rt_settings
	

func _register_categories(base: String, categories: Array[AD_SettingCategory]) -> Dictionary[StringName, AD_RuntimeSetting]:
	var rt_settings: Dictionary[StringName, AD_RuntimeSetting]
	
	for category in categories:
		rt_settings.merge(_register_category(base, category), true)
		
	
	return rt_settings
	

func generate_runtime_settings(registry: AD_SettingRegistry) -> Dictionary[StringName, AD_RuntimeSetting]:
	var rt_settings: Dictionary[StringName, AD_RuntimeSetting]
	
	rt_settings.merge(_register_settings("", registry.settings), true)
	
	rt_settings.merge(_register_categories("", registry.categories), true)
	
	return rt_settings
	
