extends Node

class_name ScoreCounter

static var singleton: ScoreCounter

static var last_time_survived: float = 0
static var time_survived: float = 0
static var highscore_time_survived: float = 0

const SAVE_PATH: String = "user://"
const SAVE_NAME: String = "highscore.tres"

signal time_tick(delta: float)

func _ready() -> void:
	singleton = self
	
	_load_highscore()
	
	$CanvasLayer/Control/HighScore.text = "Highscore: " + FormatUtils.format_time(highscore_time_survived)
	

func _on_timer_timeout() -> void:
	time_survived += $Timer.wait_time
	
	var next_index: float = ArrowSpawner.singleton.timeline_registry.timelines.find(ArrowSpawner.singleton.current_timeline) + 1
	var next_start_time: float
	
	# make sure that the index of the next element isn't out of range
	if next_index > ArrowSpawner.singleton.timeline_registry.timelines.size() - 1:
		next_start_time = ArrowSpawner.singleton.current_timeline_position
	else:
		next_start_time = ArrowSpawner.singleton.timeline_registry.timelines[next_index].start_time
	
	$CanvasLayer/Control/Counter.text = "Time survived: " + FormatUtils.format_time(time_survived)
	$CanvasLayer/Control/ProgressBar.max_value = next_start_time
	$CanvasLayer/Control/ProgressBar.value = ArrowSpawner.singleton.current_timeline_position
	$CanvasLayer/Control/ProgressInfo.text = "Time left:\n" + FormatUtils.format_time(next_start_time - ArrowSpawner.singleton.current_timeline_position)
	
	emit_signal("time_tick", $Timer.wait_time)

static func update_highscore() -> void:
	last_time_survived = time_survived
	if time_survived > highscore_time_survived:
		highscore_time_survived = time_survived
		_save_highscore()
	time_survived = 0
	

static func _save_highscore():
	var wrapper: HighscoreWrapper = HighscoreWrapper.new()
	wrapper.highscore = highscore_time_survived
	
	SaverUtils.save(wrapper, SAVE_PATH, SAVE_NAME)
	

static func _load_highscore():
	var wrapper: HighscoreWrapper = SaverUtils.load(SAVE_PATH, SAVE_NAME) as HighscoreWrapper
	
	if !wrapper: return
	
	highscore_time_survived = wrapper.highscore
	
