class_name ADPlugin_ExportPlugin
extends EditorExportPlugin

func _export_begin(
	features: PackedStringArray,
	is_debug: bool,
	path: String,
	flags: int
) -> void:
	var config: ADPlugin_ExportConfig = ResourceLoader.load("res://export_config.tres")
	if !config:
		config = ADPlugin_ExportConfig.new()
		
	
	var export_dir := path.get_base_dir()
	
	if !DirAccess.dir_exists_absolute(export_dir):
		DirAccess.make_dir_recursive_absolute(export_dir)
	
	for include_file in config.include_files:
		
		var abs_include_file := ProjectSettings.globalize_path(include_file)
		
		DirAccess.copy_absolute(abs_include_file, export_dir.path_join(abs_include_file.get_file()))
		
	
