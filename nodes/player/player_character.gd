extends CharacterBody2D

const _SPEED: float = 300.0
@export var _death_sfx: AD_AudioEffect

func _physics_process(_delta: float) -> void:
	
	var movement_y := Input.get_axis(AD_Constants.INPUT_MOVE_FORWARD, AD_Constants.INPUT_MOVE_BACKWARD)
	var movement_x := Input.get_axis(AD_Constants.INPUT_MOVE_LEFT, AD_Constants.INPUT_MOVE_RIGHT)
	var movement := Vector2(movement_x, movement_y).normalized() * _SPEED

	velocity = movement
	
	move_and_slide()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("lethal"): return
	
	printerr("You ducked up!!") # Print it as an error ;)
	
	AD_ScoreManager.update_highscore()
	
	# Play sound effect
	var sfx_player := AD_SfxPlayer.new()
	sfx_player.effect = _death_sfx
	get_tree().root.add_child(sfx_player)
	
	# Update state
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	game_state_manager.set_state(AD_GameStates.State.DEATH_SCREEN)
	
