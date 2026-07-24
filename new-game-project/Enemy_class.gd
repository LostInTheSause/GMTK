class_name Enemy_class extends Node

@export var health: int
@export var point_on_defeat: int
@export var damage_percent: float
@export var hit_box: CollisionShape2D
@export var vision_area: Area2D
@export var sprite: AnimatedSprite2D

signal attack(amount)
signal emeny_death(points)

var alerady_hit = false
var player: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage(damage_taken: int):
	if not alerady_hit:
		health -= damage_taken
		alerady_hit = true
		if health <= 0.0:
			sprite.play("death")
			emit_signal("emeny_death", point_on_defeat)
			get_parent().queue_free()
			BloodRemaing.kills += 1
			BloodRemaing.time_left += point_on_defeat
	
func deal_damage() -> void:
	emit_signal("attack", damage_percent)
	
func body_enter_sight(body:Node2D):
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	sprite.play("see_player")
	print("im so scared")
	player = body
	body.connect("player_attack", check_if_damage)
	
func check_if_damage(damage:int, attack_hitbox: Area2D):
	var hit_thing = attack_hitbox.get_overlapping_bodies()
	for i in hit_thing:
		if i.is_in_group("enemy"):
			take_damage(damage)
