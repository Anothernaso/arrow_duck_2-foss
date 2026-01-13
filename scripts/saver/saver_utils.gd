class_name SaverUtils

static func save(resource: Resource, dir: String, file_name: String, flags: int = 0) -> void:
	var file_path: String = dir + "/" + file_name
	
	if ! DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	
	ResourceSaver.save(resource, file_path, flags)
	

static func load(dir: String, file_name: String, type_hints: String = "") -> Resource:
	var file_path: String = dir + "/" + file_name
	
	if !FileAccess.file_exists(file_path):
		return null
	
	return ResourceLoader.load(file_path, type_hints)
	
