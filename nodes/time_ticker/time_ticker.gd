class_name TimeTicker
extends Node

static var singleton: TimeTicker

@onready var _timer: Timer = $Timer

signal on_tick(delta: float)
signal after_tick(delta: float)

func _ready() -> void:
	singleton = self

func _on_timer_timeout() -> void:
	on_tick.emit(_timer.wait_time)
	after_tick.emit(_timer.wait_time)
	
