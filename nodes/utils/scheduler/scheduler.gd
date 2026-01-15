class_name Scheduler
extends Node

static var singleton: Scheduler

## Determines how long (in seconds) the scheduler 
## should be idle between tasks.
@export var default_task_delay: float = 0.1
@onready var task_delay: float

var task_delta: float = 0
var tasks: Array[Task]

func enqueue_task(process: Callable, finish_callback: Callable, main_thread: bool, ...process_args: Array):
	tasks.append(Task.new(process, process_args, finish_callback, main_thread))
	

func _ready() -> void:
	singleton = self
	task_delay = default_task_delay
	

func _physics_process(delta: float) -> void:
	task_delta += delta
	
	if task_delta < task_delay: return
	task_delta = 0
	
	if tasks.is_empty(): return
	var task := tasks[0]
	
	if (task.main_thread):
		(
			func():
				if !task.finish_callback.is_valid() \
				|| !task.process.is_valid():
					return
				
				var result = task.process.call(task.process_args)
				task.finish_callback.call(result)
		).call_deferred()
	else:
		(
			func():
				if !task.finish_callback.is_valid() \
				|| !task.process.is_valid():
					return
				
				var result = task.process.call(task.process_args)
				task.finish_callback.call(result)
		).call()
	
	tasks.remove_at(0)
	
