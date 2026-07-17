class_name AD_ParticleEffect
extends Resource

@export_category("Main")
@export var amount: int = 8
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var lifetime: float = 1
@export var texture: Texture2D
@export var process_material: ParticleProcessMaterial

@export_group("Time")
@export var explosiveness: float
@export var randomness: float

@export_category("Other")

@export_group("Trails", "trail_")
@export var trail_enabled: bool = false
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var trail_lifetime: float = 0.3
@export var trail_sections: int = 8
@export var trail_section_subdivisions: int = 4
