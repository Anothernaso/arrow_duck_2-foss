extends Node

class_name Root

static var singleton: Root
@export var game_scene: PackedScene
@export var death_screen_scene: PackedScene
@export var main_menu_scene: PackedScene

var game: Game
var death_screen: DeathScreen
var main_menu: MainMenu

func _ready() -> void:
	singleton = self
	
	enter_main_menu.call_deferred()
	

func enter_game():
	
	if death_screen:
		death_screen.queue_free()
		death_screen = null
	if main_menu:
		main_menu.queue_free()
		main_menu = null
	
	if game: return
	
	game = game_scene.instantiate()
	
	add_child(game)
	

func enter_death_screen():
	
	if game:
		game.queue_free()
		game = null
	if main_menu:
		main_menu.queue_free()
		main_menu = null
	
	if death_screen: return
	
	death_screen = death_screen_scene.instantiate()
	
	add_child(death_screen)
	

func enter_main_menu():
	
	if game:
		game.queue_free()
		game = null
	if death_screen:
		death_screen.queue_free()
		death_screen = null
	
	if main_menu: return
	
	main_menu = main_menu_scene.instantiate()
	
	add_child(main_menu)
	
