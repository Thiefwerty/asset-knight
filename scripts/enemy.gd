extends CharacterBody2D
class_name Enemy


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_sprite: Sprite2D = $Sprite2D


@export var base_speed: int
@export var max_hit_points: int
@export var damage: int

var direction: Vector2
var self_attack_direction: Vector2
var self_knockback_force: Vector2
var current_hit_points: int

var is_knockback: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready():
	current_hit_points = max_hit_points

func _physics_process(delta: float) -> void:
	
	var speed = calculate_speed()

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_dead():
		die(direction.x)
	else:
		if is_knockback:
			velocity = knockback_velocity
			move_and_slide()
			knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 0.2)
			if knockback_velocity.length() < 10:
				is_knockback = false
			return
		
		velocity.x = lerp(velocity.x, direction.x * speed, 0.15)
		
		play_current_animation()
		
		move_and_slide()
	
func calculate_speed() -> float:
	return base_speed
	
func take_damage(damage, attack_direction, knockback_force):
	if !is_dead():
		current_hit_points -= damage
		animation_player.play("hit")
		knockback_velocity = Vector2(-attack_direction.x * knockback_force.x, knockback_force.y)
		is_knockback = true
	
func play_current_animation():
	if is_knockback:
		animation_player.play("hit")
	
	if direction.x > 0:
		enemy_sprite.flip_h = false
		self_attack_direction = Vector2(-1, 0)
	if direction.x < 0:
		enemy_sprite.flip_h = true
		self_attack_direction = Vector2(1, 0)
		
	animation_player.play("idle")
	
func is_dead():
	return current_hit_points <= 0
	
func die(direction):
	base_speed = 0
	if direction < 0:
		animation_player.play("death_left")
	if direction > 0:
		animation_player.play("death_right")
	
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if ["death_left", "death_right"].has(anim_name):
		queue_free()
