class_name ADPlugin_ExportPlugin
extends EditorExportPlugin

var _export_path: String

func _export_begin(
	features: PackedStringArray,
	is_debug: bool,
	path: String,
	flags: int
) -> void:
	var config: ADPlugin_ExportConfig = ResourceLoader.load("res://export_config.tres")
	if !config:
		config = ADPlugin_ExportConfig.new()
		
	
	_export_path = path
	var export_dir := path.get_base_dir()
	
	if !DirAccess.dir_exists_absolute(export_dir):
		DirAccess.make_dir_recursive_absolute(export_dir)
	#else:
	#	AUtils_DirUtils.remove_contents_recursive_absolute(export_dir)
	#	
	
	for include_file in config.include_files:
		
		var abs_include_file := ProjectSettings.globalize_path(include_file)
		
		DirAccess.copy_absolute(abs_include_file, export_dir.path_join(abs_include_file.get_file()))
		
	

func _export_end() -> void:
	var config: ADPlugin_ExportConfig = ResourceLoader.load("res://export_config.tres")
	if !config:
		config = ADPlugin_ExportConfig.new()
	
	var path := _export_path
	var export_dir := path.get_base_dir()
	
	var proj_version: String = ProjectSettings.get_setting("application/config/version", "")
	
	var zip_path := export_dir.path_join(config.project_name)
	if proj_version != "":
		zip_path += "-" + proj_version
	
	zip_path += ".zip"
	
	print("Packaging export at: " + zip_path)
	
	var packer := ZIPPacker.new()
	var result := packer.open(zip_path)
	if result != Error.OK:
		push_error("Failed to open zip: %s" % zip_path)
		return
	
	ADPlugin_ZIPUtils.add_directory(packer, export_dir, export_dir)
	
	packer.close()
	
