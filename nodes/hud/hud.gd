extends Node

@onready var level_progres_bar: ProgressBar = $Control/VBoxContainer/LevelProgressBar
@onready var level_progres_info_label: Label = $Control/VBoxContainer/LevelProgressInfo
@onready var score_counter_label: Label = $Control/VBoxContainer/ScoreCounter
@onready var highscore_counter_label: Label = $Control/VBoxContainer/HighscoreCounter


func _ready() -> void:
	_init_.call_deferred()
	

func _init_() -> void:
	TimeTicker.singleton.after_tick.connect(_after_tick)
	highscore_counter_label.text = "Highscore: " + FormatUtils.format_time(AD_ScoreManager.highscore_time_survived)
	

func _after_tick(_delta: float) -> void:
	# Get the time where the next timeline will begin
	# so that we can update the HUD accordingly.
	var next_index: float = ArrowSpawner.singleton.timeline_registry.timelines.find(ArrowSpawner.singleton.current_timeline) + 1
	var next_start_time: float
	
	# Make sure that the index of the next element isn't out of range
	if next_index > ArrowSpawner.singleton.timeline_registry.timelines.size() - 1:
		next_start_time = ArrowSpawner.singleton.current_timeline_position
	else:
		next_start_time = ArrowSpawner.singleton.timeline_registry.timelines[next_index].start_time
	
	# Update the HUD
	score_counter_label.text = "Time Survived: " + FormatUtils.format_time(AD_ScoreManager.time_survived)
	level_progres_bar.max_value = next_start_time
	level_progres_bar.value = ArrowSpawner.singleton.current_timeline_position
	level_progres_info_label.text = "Time Left:\n" + FormatUtils.format_time(next_start_time - ArrowSpawner.singleton.current_timeline_position)
	
