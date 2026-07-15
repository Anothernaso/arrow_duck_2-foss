class_name AD_ArrowSpawner
extends Node2D

static var singleton: AD_ArrowSpawner

@export var min_spawn_point_node: Node2D
@export var max_spawn_point_node: Node2D

static var min_spawn_point: Vector2
static var max_spawn_point: Vector2

## I don't even know what this does.
## It doesn't seem to have any usages.
## I probably stopped using it when I added the ScoreCounter back in 2024.
## 
## I should search through the codebase using `ripgrep` some day.
##
## - Anatnaso
##
@export var spawn_delay: float = 3
@export var timeline_registry: ArrowTimelineRegistry

@onready var arrow_holder: Node2D = $ArrowHolder

var current_timeline_position: float = 0
var total_timeline_position: float = 0

static var current_timeline: ArrowTimeline = null

func _ready() -> void:
	singleton = self
	initialize.call_deferred()

## A function that resets the current timeline.
## It also resets the current score.
func restart_current_timeline() -> void:
	total_timeline_position -= current_timeline_position
	AD_ScoreManager.time_survived = 0
	current_timeline_position = 0

## Initializes the ArrowSpawner.
func initialize() -> void:
	min_spawn_point = min_spawn_point_node.global_position
	max_spawn_point = max_spawn_point_node.global_position
	
	AD_TimeTicker.singleton.on_tick.connect(time_tick)
	
	if current_timeline == null:
		load_tl()
	
	update_timeline()
	

## A functions that ticks the timeline.
func time_tick(delta: float) -> void:
	current_timeline_position += delta
	total_timeline_position += delta
	update_timeline()
	spawn_random()
	

## A function that checks if the current timeline has finished,
## if so, it sets the next timeline as the current one.
## This functions should run every time-tick.
func update_timeline() -> void:
	for timeline: ArrowTimeline in timeline_registry.timelines:
		if roundi(current_timeline_position) != roundi(timeline.start_time): continue
		if timeline_registry.timelines.find(timeline) != timeline_registry.timelines.find(current_timeline) + 1: continue
		
		current_timeline = timeline
		current_timeline_position = 0
		
		save_tl()
		return
		
	

## A function that is called every time-tick and handles arrow spawning.
## It finds the correct arrows to spawn and spawns them.
func spawn_random() -> void:
	print("WEEE WOOOO WEEE WOOO!! Spawning Arrow...")
	
	if !current_timeline: return
	
	for arrow: ArrowSequence in current_timeline.registry:
		
		# make sure the arrow only spawns if we are in the arrow's time zone
		if arrow.min_survival_time > current_timeline_position or arrow.max_survival_time < current_timeline_position:
			continue
		
		var spawn_pos := AD_Vector2Utils.randv2_range(min_spawn_point, max_spawn_point) 
		
		var arrow_node: Node2D = arrow.scene.instantiate()
		arrow_node.global_position = spawn_pos
		arrow_holder.add_child.call_deferred(arrow_node)
		
	

## Saves the timeline that we are currently in.
func save_tl() -> void:
	var wrapper := AD_CurrentTimelineWrapper.new()
	wrapper.current_timeline_index = timeline_registry.timelines.rfind(current_timeline)
	
	AD_SaverUtils.save(wrapper, AD_Constants.PERSISTENT_DIR_PATH, AD_Constants.CURRENT_TIMELINE_FILE_NAME)

## Loads the timeline that we were in when saving.
func load_tl() -> void:
	var wrapper := AD_SaverUtils.load(AD_Constants.PERSISTENT_DIR_PATH, AD_Constants.CURRENT_TIMELINE_FILE_NAME) as AD_CurrentTimelineWrapper
	
	if !wrapper:
		current_timeline = timeline_registry.timelines[0]
		return
	
	current_timeline = timeline_registry.timelines[wrapper.current_timeline_index]
	
