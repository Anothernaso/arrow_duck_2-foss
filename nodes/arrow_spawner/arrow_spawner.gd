class_name ArrowSpawner
extends Node2D

static var singleton: ArrowSpawner

const PERSISTENT_DIR: String = "user://persistent"
const CURRENT_TIMELINE_FILE_NAME: String = "data.tres"

@export var min_spawn_point_node: Node2D
@export var max_spawn_point_node: Node2D
@export var min_destruction_point_node: Node2D

static var min_spawn_point: Vector2
static var max_spawn_point: Vector2
static var min_destruction_point: Vector2

@export var spawn_delay: float = 3
@export var timeline_registry: ArrowTimelineRegistry

@onready var arrow_holder: Node2D = $ArrowHolder

var current_timeline_position: float = 0
var total_timeline_position: float = 0

static var current_timeline: ArrowTimeline = null

func _ready() -> void:
	singleton = self
	set_up.call_deferred()

## A function that resets the current timeline.
## It also resets the current score.
func restart_current_timeline() -> void:
	total_timeline_position -= current_timeline_position
	ScoreCounter.singleton.time_survived = 0
	current_timeline_position = 0

## Sets up the ArrowSpawner.
func set_up() -> void:
	min_spawn_point = min_spawn_point_node.position
	max_spawn_point = max_spawn_point_node.position
	min_destruction_point = min_destruction_point_node.position
	
	# I have no idea why the ScoreManager is ticking the ArrowSpawner.
	# It should be the other way around.
	ScoreCounter.singleton.time_tick.connect(time_tick)
	
	if current_timeline == null:
		load_tl()
	
	update_timeline()
	

## A functions that ticks the timeline.
func time_tick(_delta: float) -> void:
	current_timeline_position += 1
	total_timeline_position += 1
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
	print("📢 WEEE WOOOO WEEE WOOO!! Spawning Arrow! 📢")
	
	if !current_timeline: return
	
	for arrow: ArrowSequence in current_timeline.registry:
		
		# make sure the arrow only spawns if we are in the arrow's time zone
		if arrow.min_survival_time > current_timeline_position or arrow.max_survival_time < current_timeline_position:
			continue
		
		var spawn_pos_y: float = randi_range(min_spawn_point.y, max_spawn_point.y)
		var spawn_pos_x: float = randi_range(min_spawn_point.x, max_spawn_point.x)
	
		var spawn_pos: Vector2 = Vector2(spawn_pos_x, spawn_pos_y)
		
		var arrow_node: Node2D = arrow.scene.instantiate()
		arrow_node.position = spawn_pos
		arrow_holder.add_child.call_deferred(arrow_node)
		
	

## Saves what timeline we are currently in.
func save_tl() -> void:
	var data: SaveDataWrapper = SaveDataWrapper.new()
	data.current_timeline_index = timeline_registry.timelines.rfind(current_timeline)
	
	SaverUtils.save(data, PERSISTENT_DIR, CURRENT_TIMELINE_FILE_NAME)

## Loads what timeline we were in when saving.
func load_tl() -> void:
	var data: SaveDataWrapper = SaverUtils.load(PERSISTENT_DIR, CURRENT_TIMELINE_FILE_NAME)
	
	if !data:
		current_timeline = timeline_registry.timelines[0]
		return
	
	current_timeline = timeline_registry.timelines[data.current_timeline_index]
	
