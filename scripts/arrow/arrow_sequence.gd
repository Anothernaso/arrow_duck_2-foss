extends Resource

class_name ArrowSequence

## The delay from the beginning of the timeline to when
## the arrows should start spawning.
@export var min_survival_time: int = 0

## The delay from the beginning of the timeline to when
## the arrows should stop spawning.
@export var max_survival_time: int = 100

## The arrow scene that should be spawned in this sequence.
@export var scene: PackedScene
