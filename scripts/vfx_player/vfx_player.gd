# TODO: Finish implementation
class_name AD_VfxPlayer
extends GPUParticles2D

@export var effect: AD_ParticleEffect

func _ready() -> void:
	finished.connect(_on_finished)
	
	one_shot = true
	
	amount = effect.amount
	lifetime = effect.lifetime
	texture = effect.texture
	process_material = effect.process_material
	
	explosiveness = effect.explosiveness
	randomness = effect.randomness
	
	trail_enabled = effect.trail_enabled
	trail_lifetime = effect.trail_lifetime
	trail_sections = effect.trail_sections
	trail_section_subdivisions = effect.trail_section_subdivisions
	

func _on_finished() -> void:
	queue_free()
	
