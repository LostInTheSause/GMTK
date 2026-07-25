extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $Area2D

@export var max_speed: float = 100
@export var acceleration: float
@export var friction: float
@export var jump_acceleration: float
@export var slide_speed:float
@export var dash_speed: float
@export var edge_jump_acceleration: float

var jump_buffer = false
var jump_buffer_timer = 0.15
var can_jump = false

var double_jump = false
var special_jump = false
var dash = false
var slidden = false
var slide_cooldown = 1.0

signal player_attack(damage:int, attack_hitbox: Area2D)
@export var attack_frames_active = false
@export var attack_cued = false
var damage = 0

var fall_start_played = false


func _ready() -> void:
	self.add_to_group("player")
	

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight = delta *(acceleration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * max_speed,  velocity_weight)

	if velocity.x < 0.0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	var facing_dir: int = 1
	if animated_sprite_2d.flip_h:
		facing_dir = -1
	else:
		facing_dir = 1
	
	if x_input and is_on_floor() and not slidden:
		animated_sprite_2d.play("walk")
	elif is_on_floor() and not slidden:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_just_pressed("jump"):
			jump_buffer = true
	elif is_on_floor():
		can_jump = true
		special_jump = false
		dash = false
		animated_sprite_2d.offset = Vector2.ZERO
	if jump_buffer:
		jump_buffer_timer -= delta
	
	jump()
	if not is_on_floor() and not special_jump:
		if Input.is_action_just_pressed("jump"):
			double_jump = true
			special_jump = true
			jump()
	if Input.is_action_just_pressed("slide") and not is_on_floor() and not dash:
		velocity.x += dash_speed*x_input
		animated_sprite_2d.offset = Vector2.ZERO
		animated_sprite_2d.stop()
		animated_sprite_2d.play("dash")
		
		velocity.y = 0
		dash=true
	if can_jump and Input.is_action_just_pressed("slide") and not slidden:
		slidden = true
		velocity.x += slide_speed * (x_input ) 
		if not x_input:
			velocity.x += slide_speed*(facing_dir)
		animated_sprite_2d.play("slide")
		velocity.y = 0
	elif slidden:
		slide_cooldown -= delta
		if slide_cooldown < 0.0:
			slidden = false
			slide_cooldown = 1.0
	attack()
	if attack_frames_active:
		emit_signal("player_attack",damage, attack_area)
		attack_frames_active = false
		
	if velocity.y > 0 and not fall_start_played:
		animated_sprite_2d.offset = Vector2.ZERO
		animated_sprite_2d.play("fall_start")
		
		animated_sprite_2d.animation_finished.connect(play_fall)
	print(velocity.y)
	move_and_slide()
	
	
	
func jump() -> void:
	if is_on_floor() or double_jump:
		if Input.is_action_just_pressed("jump") or (jump_buffer_timer >= 0.00 and jump_buffer):
			velocity.y = jump_acceleration
			can_jump = false
			jump_buffer = false
			jump_buffer_timer = 0.15
			double_jump = false
			if double_jump:
				animated_sprite_2d.play("double_jump")
			else:
				animated_sprite_2d.offset.y = -27.5
				animated_sprite_2d.play("jump")
				animated_sprite_2d.animation_finished.connect(jump_ani_fin)
	#elif velocity.y < 0.0:
		#if Input.is_action_just_released("jump"):
			#velocity.y *= 0.5
			#if double_jump:
				#animated_sprite_2d.play("double_jump")
			#else:
				#animated_sprite_2d.play("jump")
#	
func attack() -> void:
	if Input.is_action_just_pressed("attack_1") and not attack_cued:
		damage = 1
		animation_player.play("quick_attack")
	elif Input.is_action_just_pressed("attack_2") and not attack_cued:
		damage = 3
		animation_player.play("heavy_attack")
		
	elif Input.is_action_just_pressed("special_attack") and not attack_cued and BloodRemaing.kills % 5 == 0:
		damage = 6
		animation_player.play("special_attack")
		

func play_fall():
	animated_sprite_2d.play("fall")
	
func jump_ani_fin():
	animated_sprite_2d.offset.y = 0
	if velocity.y < 0:
		animated_sprite_2d.play("in_air")
