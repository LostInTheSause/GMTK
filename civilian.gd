extends Node2D
@onready var enemy: CharacterBody2D = $enemy
@onready var enemy_class: Enemy_class = $enemy/Enemy_class

@onready var ground_checker: RayCast2D = $ground_checker
@onready var land_in_front_checker: RayCast2D = $land_in_front_checker
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var collision_shape_2d: CollisionShape2D = $enemy/Area2D/CollisionShape2D

var in_panic = false
@export var x_dir = 1
var runing = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_class.in_panic.connect(start_panic)
	animated_sprite_2d.animation_finished.connect(start_run)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_panic:
		if not runing:
			animated_sprite_2d.play("panic")
			
		else:
			animated_sprite_2d.play("run")
		
		if ground_checker.is_colliding() and not land_in_front_checker.is_colliding() and runing:

			self.position.x += 200 * delta * x_dir
			
			
	if enemy_class.health <= 0.0:
		animated_sprite_2d.play("death")
		in_panic = false
		animated_sprite_2d.animation_finished.connect(they_dead)

func start_panic():
	in_panic = true
	
func start_run():
	animated_sprite_2d.animation_finished.disconnect(start_run)
	runing = true

func they_dead():
	self.queue_free()
