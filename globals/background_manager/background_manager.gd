class_name AD_BackgroundManager
extends Node

@export var _default_background: AD_Background
@onready var _background_root: Node2D = $BackgroundRoot

var _current_background: AD_Background
var _current_background_node: Node2D

func _ready() -> void:
	if _default_background:
		set_background.call_deferred(_default_background)
		
	

func set_background(background: AD_Background, force: bool = false) -> void:
	if !force && background == _current_background && _current_background_node:
		return
		
	
	print("Changing background to: " + background.resource_path)
	
	_current_background = background
	
	if _current_background_node:
		_current_background_node.queue_free()
		
	
	if !background:
		_current_background_node = null
		return
		
	
	_current_background_node = Node2D.new()
	_background_root.add_child(_current_background_node)
	
	for layer in background.layers:
		var texture := load(layer.texture_path) as Texture2D
		
		var scale := background.scale * layer.scale
		var size := texture.get_size() * scale
		
		var parallax := Parallax2D.new()
		_current_background_node.add_child(parallax)
		
		parallax.z_index = layer.z_index
		parallax.autoscroll.x = layer.speed
		parallax.repeat_size = size
		parallax.repeat_times = 4
		
		var sprite := Sprite2D.new()
		parallax.add_child(sprite)
		
		sprite.scale = scale
		sprite.texture = texture
		
	
