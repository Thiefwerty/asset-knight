extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const DASH_SPEED = 250.0
const DASH_DURATION = 0.3 
const DASH_COOLDOWN = 0.3
const MAX_JUMPS: int = 2

enum {
	MOVE,
	JUMP,
	ATTACK,
	TAKE_DAMAGE,
	SHIFT,
	DIE,
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_base: Node2D = $WeaponBase
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var damage_cooldown_timer: Timer = $DamageCooldownTimer

@export var max_hp: int = 40

var knockback_velocity: Vector2 = Vector2.ZERO
var shift_speed: int = 500

var current_weapon: Node2D = null

var current_hp: int 
var current_gold: int = 0

var damage_cooldown: bool = false

var death_animation_played: bool = false

var current_animation: String = "idle"
var state = MOVE

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var can_dash: bool = true
var dash_cooldown_timer: float = 0.0

var jump_count: int = 0
var was_on_floor: bool = true

func _ready():
	var sword_scene = preload("res://sword.tscn")
	equip_weapon(sword_scene)
	
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	
	match state:
		MOVE:
			move_state(delta)
		JUMP:
			jump_state()
		ATTACK:
			attack_state()
		SHIFT:
			shift_state(delta)
		TAKE_DAMAGE:
			take_damage_state()
		DIE:
			die_state()
			
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if not was_on_floor:
			jump_count = 0
	was_on_floor = is_on_floor()
	
	if Input.is_action_just_pressed("player_jump") and jump_count < MAX_JUMPS \
		and state not in [DIE, TAKE_DAMAGE] and (is_on_floor() or jump_count > 0):
			state = JUMP
			jump_count += 1
		
	move_and_slide()
		
func move_state(delta):
	is_dashing = false
	var direction := Input.get_axis("player_left", "player_right")
	
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animation_player.play("idle")
	
	if direction < 0:
		player_sprite.flip_h = true
		current_weapon.flip_h = true
	elif direction > 0:
		player_sprite.flip_h = false
		current_weapon.flip_h = false
		
	if current_hp <= 0:
		current_hp = 0
		state = DIE
		await animation_player.animation_finished
		Engine.time_scale = 1.0
		get_tree().change_scene_to_file("res://menu.tscn")
		
	if Input.is_action_just_pressed("player_shift") and can_dash:
		dash_direction = Vector2.RIGHT if not player_sprite.flip_h else Vector2.LEFT
		state = SHIFT
		
	if not can_dash:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			can_dash = true
		
	if Input.is_action_just_pressed("player_hit"):
		state = ATTACK
		
func shift_state(delta):
	if not is_dashing:
		can_dash = false
		is_dashing = true
		dash_cooldown_timer = DASH_COOLDOWN
		dash_timer = DASH_DURATION
		velocity = dash_direction * DASH_SPEED
		animation_player.play("roll")
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			state = MOVE
		
func jump_state():
	velocity.y = JUMP_VELOCITY
	animation_player.play("jump")
	state = MOVE

func attack_state():
	current_weapon.attack()
	state = MOVE

func die_state():
	velocity.x = 0
	Engine.time_scale = 0.5
	animation_player.play("death")
	current_weapon.visible = false
	
func equip_weapon(weapon_scene: PackedScene):
	if current_weapon:
		current_weapon.queue_free()
	current_weapon = weapon_scene.instantiate()
	weapon_base.add_child(current_weapon)
	 
func take_damage(damage, attack_direction, knockback_force):
	if !damage_cooldown and !is_dashing:
		current_hp -= damage
		knockback_velocity = Vector2(-attack_direction.x * knockback_force.x, knockback_force.y)
		state = TAKE_DAMAGE
		
func take_damage_state():
	damage_cooldown = true
	damage_cooldown_timer.start()
	animation_player.play("hit")
	velocity = knockback_velocity
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 0.2)
	if knockback_velocity.length() < 30:
		state = MOVE
		
func _on_damage_cooldown_timer_timeout() -> void:
	damage_cooldown = false
