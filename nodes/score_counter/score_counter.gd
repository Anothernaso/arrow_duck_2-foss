extends Node

class_name ScoreCounter

static var singleton: ScoreCounter

static var last_time_survived: float = 0
static var time_survived: float = 0
static var highscore_time_survived: float = 0

func _ready() -> void:
	singleton = self
	
	_load_highscore()
	$CanvasLayer/Control/HighScore.text = "Highscore: " + FormatUtils.format_time(highscore_time_survived)
	
	initialize.call_deferred()
	

func initialize() -> void:
	TimeTicker.singleton.after_tick.connect(_after_tick)

func _after_tick(delta: float) -> void:
	time_survived += delta
	
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
	$CanvasLayer/Control/Counter.text = "Time survived: " + FormatUtils.format_time(time_survived)
	$CanvasLayer/Control/ProgressBar.max_value = next_start_time
	$CanvasLayer/Control/ProgressBar.value = ArrowSpawner.singleton.current_timeline_position
	$CanvasLayer/Control/ProgressInfo.text = "Time left:\n" + FormatUtils.format_time(next_start_time - ArrowSpawner.singleton.current_timeline_position)
	

static func update_highscore() -> void:
	last_time_survived = time_survived
	if time_survived > highscore_time_survived:
		highscore_time_survived = time_survived
		_save_highscore()
	time_survived = 0
	

static func _save_highscore() -> void:
	var wrapper: HighscoreWrapper = HighscoreWrapper.new()
	wrapper.highscore = highscore_time_survived
	
	SaverUtils.save(wrapper, Constants.PERSISTENT_DIR, Constants.HIGHSCORE_FILE_NAME)
	

static func _load_highscore() -> void:
	var wrapper := SaverUtils.load(Constants.PERSISTENT_DIR, Constants.HIGHSCORE_FILE_NAME) as HighscoreWrapper
	
	if !wrapper: return
	
	highscore_time_survived = wrapper.highscore
	
