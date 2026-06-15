class_name ADPlugin_ZIPUtils

static func add_directory(packer: ZIPPacker, base_dir: String, current_dir: String) -> Error:
	var dir := DirAccess.open(current_dir)
	if dir == null:
		return Error.ERR_CANT_OPEN
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue
			
		
		var full_path := current_dir.path_join(file_name)
		
		if dir.current_is_dir():
			var result := add_directory(packer, base_dir, full_path)
			if result != Error.OK:
				return result
		else:
			var relative_path := full_path.trim_prefix(base_dir + "/")
			relative_path = relative_path.simplify_path()
			
			var file := FileAccess.open(full_path, FileAccess.READ)
			if file:
				var data := file.get_buffer(file.get_length())
				
				packer.start_file(relative_path)
				packer.write_file(data)
				packer.close_file()
				
			
		
		
		file_name = dir.get_next()
		
	
	dir.list_dir_end()
	
	return Error.OK
	
