class_name Enemy_class extends Node

@export var health: int
@export var point_on_defeat: int
@export var damage_percent: float
@export var hit_box: CollisionShape2D
@export var vision_area: Area2D
@export var sprite: AnimatedSprite2D

signal in_panic()

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
	emit_signal("in_panic")
	print("im so scared")
	player = body
	BloodRemaing.player_attack.connect(check_if_damage)
	
func check_if_damage(damage:int, attack_hitbox: Area2D):
	print("fsf")
	if attack_hitbox.global_position.x + 39 > hit_box.global_position.x and hit_box.global_position.x > attack_hitbox.global_position.x - 39:
		if attack_hitbox.global_position.y + 35 > hit_box.global_position.y and hit_box.global_position.y > attack_hitbox.global_position.y - 35:
			take_damage(damage)
			alerady_hit = false
