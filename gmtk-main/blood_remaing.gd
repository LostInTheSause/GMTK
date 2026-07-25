extends Node

var total_time = 60
var time_left: float = 60
var kills: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0.0:
		print("u ded")
