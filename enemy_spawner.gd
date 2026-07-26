extends Node2D

@export var enemy: PackedScene
@export var spawning_rate: int
var time_spent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_spent = spawning_rate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawning_rate -= delta
	if spawning_rate <= 0:
		pass
		
