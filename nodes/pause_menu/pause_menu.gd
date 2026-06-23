extends CanvasLayer


func _on_resume_button_down() -> void:
	AD_PauseManager.singleton.set_state(AD_PauseManager.PauseState.RUNNING)
	


func _on_main_menu_button_down() -> void:
	var game_state_manager: AD_GameStateManager = AD_GlobalGameStateManager
	
	# TODO: Make sure this doesn't cause trouble
	game_state_manager.set_state(AD_GameStates.State.MAIN_MENU)
	
