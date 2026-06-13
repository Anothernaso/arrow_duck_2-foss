@tool
class_name ADPlugin_EditorPlugin
extends EditorPlugin

var export_plugin: ADPlugin_ExportPlugin

func _enter_tree() -> void:
	export_plugin = ADPlugin_ExportPlugin.new()
	
	add_export_plugin(export_plugin)
	

func _exit_tree():
	remove_export_plugin(export_plugin)
