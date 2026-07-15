class_name AD_ScoreManager
extends Node

static var last_time_survived: float = 0
static var time_survived: float = 0
static var highscore_time_survived: float = 0


func _ready() -> void:
	AD_TimeTicker.singleton.after_tick.connect.call_deferred(_after_tick)
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
	var wrapper := AD_HighscoreWrapper.new()
	wrapper.highscore = highscore_time_survived
	
	AD_SaverUtils.save(wrapper, AD_Constants.PERSISTENT_DIR_PATH, AD_Constants.HIGHSCORE_FILE_NAME)
	

static func _load_highscore() -> void:
	var wrapper := AD_SaverUtils.load(AD_Constants.PERSISTENT_DIR_PATH, AD_Constants.HIGHSCORE_FILE_NAME) as AD_HighscoreWrapper
	
	if !wrapper: return
	
	highscore_time_survived = wrapper.highscore
	
