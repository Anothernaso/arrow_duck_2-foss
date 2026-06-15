class_name AUtils_DirUtils

## Recursively removes the contents of the given directory
## where `path` is the filepath/URI/URL of the directory.
##
## # Returns
##
## `Error.OK` on success.
## `!Error.OK` on failure.
##
static func remove_contents_recursive_absolute(path: String) -> Error:
	var dir = DirAccess.open(path)
	if !dir:
		return Error.ERR_CANT_OPEN
	
	var result: Error
	
	result = dir.list_dir_begin()
	if result != Error.OK:
		return result
	
	var filename := dir.get_next()
	
	while filename != "":
		if filename != "." && filename != "..":
			var full_path := path.path_join(filename)
			
			if dir.current_is_dir():
				result = remove_directory_recursive_absolute(full_path)
				if result != Error.OK:
					return result
			else:
				result = DirAccess.remove_absolute(full_path)
				if result != Error.OK:
					return result
				
			
		
		filename = dir.get_next()
		
	
	dir.list_dir_end()
	
	return Error.OK
	

## Recursively removes the given directory and all its contents
## where `path` is the filepath/URI/URL of the directory.
##
## # Returns
##
## `Error.OK` on success.
## `!Error.OK` on failure.
##
static func remove_directory_recursive_absolute(path: String) -> Error:
	var result := remove_contents_recursive_absolute(path)
	if result != Error.OK:
		return result
	
	return DirAccess.remove_absolute(path)
	
