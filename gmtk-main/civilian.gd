extends Node2D
@onready var enemy: CharacterBody2D = $enemy

@onready var ground_checker: RayCast2D = $ground_checker
@onready var land_in_front_checker: RayCast2D = $land_in_front_checker
@onready var animated_sprite_2d: AnimatedSprite2D = $enemy/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $enemy/Area2D/CollisionShape2D

var in_panic = false
var x_dir = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_panic:
		animated_sprite_2d.play("panic")
		if ground_checker.is_colliding() and not land_in_front_checker.is_colliding():
			self.position.x += 200 * delta * x_dir
		else:
			if not animated_sprite_2d.flip_h:
				animated_sprite_2d.flip_h = true
			else:
				animated_sprite_2d.flip_h = false
			x_dir *= -1
