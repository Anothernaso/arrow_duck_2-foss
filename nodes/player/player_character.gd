extends CharacterBody2D

class_name PlayerCharacter

@export var speed = 300.0
@export var sfx_player_scene: PackedScene
@export var death_sfx: AudioStream

var is_down: bool = false
var is_up: bool = false
var is_right: bool = false
var is_left: bool = false

var use_touch: bool = false

func _ready() -> void:
	use_touch = OS.has_feature("mobile")
	if !use_touch:
		$TouchScreenUI.queue_free()
	

func _physics_process(_delta: float) -> void:
	
	var touch: Vector2
	
	if is_down:
		touch.y = 1
	if is_up:
		touch.y = -1
	if is_left:
		touch.x = -1
	if is_right:
		touch.x = 1
	
	var movement_y := Input.get_axis("forward", "backward")
	var movement_x := Input.get_axis("left", "right")
	var movement: Vector2
	
	if !use_touch:
		movement = Vector2(movement_x, movement_y).normalized() * speed
	else:
		movement = touch.normalized() * speed
	
	velocity = movement
	
	move_and_slide()
	

func _on_area_2d_body_entered(_body: Node2D) -> void:
	printerr("💀🦆 You ducked up!! 🦆💀")
	
	ScoreCounter.update_highscore()
	
	var sfx_player := sfx_player_scene.instantiate() as AudioStreamPlayer
	sfx_player.stream = death_sfx
	get_tree().root.add_child(sfx_player)
	
	GameStateManager.set_state(GameStates.State.DeathScreen)
	


func _on_down_button_down() -> void:
	is_down = true
func _on_down_button_up() -> void:
	is_down = false


func _on_up_button_down() -> void:
	is_up = true
func _on_up_button_up() -> void:
	is_up = false


func _on_right_button_down() -> void:
	is_right = true
func _on_right_button_up() -> void:
	is_right = false


func _on_left_button_down() -> void:
	is_left = true
func _on_left_button_up() -> void:
	is_left = false
