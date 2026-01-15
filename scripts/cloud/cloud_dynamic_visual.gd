extends Sprite2D

func _enter_tree() -> void:
	var zi: int
	match randi_range(0, 4):
		0:
			zi = 0
		1:
			zi = -2
		2:
			zi = -4
		3:
			zi = -6
		4:
			zi = -8
			
		
	
	z_index = zi
	
