class_name SaverUtils

static func save(resource: Resource, path: String, file_name: String, flags: int = 0) -> void:
	var file_path: String = path + "/" + file_name
	
	if ! DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path)
	
	ResourceSaver.save(resource, file_path, flags)
	

static func load(path: String, file_name: String, type_hints: String = "") -> Resource:
	var file_path: String = path + "/" + file_name
	
	if !FileAccess.file_exists(file_path):
		return null
	
	return ResourceLoader.load(file_path, type_hints)
	
