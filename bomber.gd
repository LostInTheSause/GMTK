extends Node2D

@onready var enemy_class: Enemy_class = $enemy_base/Enemy_class
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_radius: Area2D = $explosion_radius

var burn = false
var hurt = false
var total_time_burn = 0
var already_done = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_class.health <= 0.0:
		animated_sprite_2d.play("death")
		
		animated_sprite_2d.animation_finished.connect(they_dead)
		

	
	if burn:
		get_tree().create_timer(1).timeout.connect(deal_burn_damage)
		burn = false

	
func they_dead():
	self.queue_free()


func _on_bomb_dection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not already_done:
		await get_tree().create_timer(0.4).timeout
		animated_sprite_2d.play("fuse")
		animated_sprite_2d.animation_finished.connect(explode)
		already_done = true

		
func fire_starter():
	animated_sprite_2d.play("fire")
	animated_sprite_2d.animation_finished.disconnect(fire_starter)
	animated_sprite_2d.animation_finished.connect(they_dead)
	
func deal_damage(body):
	if animated_sprite_2d.animation == "fire":
		burn = true
	if animated_sprite_2d.animation == "explode" and not hurt:
		BloodRemaing.time_left *= 0.5
	

func deal_burn_damage():
	total_time_burn += 1
	BloodRemaing.time_left *= 0.95
	if total_time_burn == 4:
		return
	else:
		burn = true

func explode():
	animated_sprite_2d.play("explode")
	animated_sprite_2d.animation_finished.disconnect(explode)
	animated_sprite_2d.animation_finished.connect(fire_starter)
