class_name Task
extends RefCounted

@warning_ignore("shadowed_variable")
func _init(
	process: Callable,
	process_args: Array[Variant],
	finish_callback: Callable,
	main_thread: bool
	) -> void:
	self.process = process
	self.process_args = process_args
	self.finish_callback = finish_callback
	self.main_thread = main_thread
	

var process: Callable
var process_args: Array[Variant]
var finish_callback: Callable

var main_thread: bool
