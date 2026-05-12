class_name AD_ScoreManager
extends Node

static var last_time_survived: float = 0
static var time_survived: float = 0
static var highscore_time_survived: float = 0


func _ready() -> void:
	TimeTicker.singleton.after_tick.connect.call_deferred(_after_tick)
	_load_highscore()
	

func _after_tick(delta: float) -> void:
	time_survived += delta

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
	
