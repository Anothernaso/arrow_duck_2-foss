class_name ADPlugin_ZIPUtils

## Streams the given file to the given `ZIPPacker`
## where `packer` is the `ZIPPacker`,
## `src_path` is the path to the file
## and `dst_path` is the destination path inside of the ZIP
## where the file will be written to.
##
## # Returns
##
## `Error.OK` on success.
## `!Error.OK` on failure.
##
static func add_file(
	packer: ZIPPacker,
	src_path: String,
	dst_path: String,
	buffer_size: int = AUtils_Constants.DEFAULT_BUFFER_SIZE
	) -> Error:
	var error: Error
	
	var file := FileAccess.open(src_path, FileAccess.READ)
	if !file:
		return FileAccess.get_open_error()
		
	
	error = packer.start_file(dst_path)
	if error:
		return error
		
	
	while !file.eof_reached():
		var chunk := file.get_buffer(buffer_size)
		
		error = packer.write_file(chunk)
		if error:
			return error
			
		
	
	error = packer.close_file()
	if error:
		return error
		
	
	return Error.OK
	

static func add_directory(packer: ZIPPacker, base_dir: String, current_dir: String) -> Error:
	var error: Error
	
	var dir := DirAccess.open(current_dir)
	if !dir:
		return DirAccess.get_open_error()
		
	
	error = dir.list_dir_begin()
	if error:
		return error
		
	
	var file_name := dir.get_next()
	
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue
			
		
		var full_path := current_dir.path_join(file_name)
		
		if dir.current_is_dir():
			error = add_directory(packer, base_dir, full_path)
			if error:
				return error
		else:
			var relative_path := full_path.trim_prefix(base_dir + "/")
			relative_path = relative_path.simplify_path()
			
			error = add_file(packer, full_path, relative_path)
			if error:
				return error
				
			
		
		
		file_name = dir.get_next()
		
	
	dir.list_dir_end()
	
	return Error.OK
	
