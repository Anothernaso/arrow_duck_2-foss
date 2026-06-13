class_name ADPlugin_DirUtils

static func remove_contents_recursive_absolute(path: String) -> Error:
	var dir = DirAccess.open(path)
	if !dir:
		return Error.ERR_CANT_OPEN
	
	var result := dir.list_dir_begin()
	if result != Error.OK:
		return result
	
	var filename := dir.get_next()
	
	while filename != "":
		if filename != "." && filename != "..":
			var full_path := path.path_join(filename)
			
			if dir.current_is_dir():
				var result_ := remove_directory_recursive_absolute(full_path)
				if result_ != Error.OK:
					return result_
			else:
				var result_ := DirAccess.remove_absolute(full_path)
				if result_ != Error.OK:
					return result_
				
			
		
		filename = dir.get_next()
		
	
	dir.list_dir_end()
	
	return Error.OK
	

static func remove_directory_recursive_absolute(path: String) -> Error:
	var result := remove_directory_recursive_absolute(path)
	if result != Error.OK:
		return result
	
	return DirAccess.remove_absolute(path)
	
