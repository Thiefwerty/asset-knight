extends Node2D
class_name WeaponBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var timer: Timer = $WeaponCollision/Timer

@export var damage: int
@export var attack_speed: float

var flip_h: bool = false
var is_attack: bool = false
var in_colldown: bool = false

var start_position: Vector2
var self_attack_direction: Vector2
var self_knockback_force: Vector2
var start_roatation: float
var enemies_in_range = []


func _ready() -> void:
	start_position = position
	start_roatation = rotation
	
func _process(delta: float) -> void:
	if flip_h == false:
		position.x = start_position.x
		rotation = start_roatation
		self_attack_direction = Vector2(-1, 0)
	if flip_h == true:
		position.x = -start_position.x
		rotation = -start_roatation
		self_attack_direction = Vector2(1, 0)
	if is_attack and !in_colldown:
		make_damage()
		
func attack():
	is_attack = true
	if flip_h == false:
		animation_player.play("attack_right")
	if flip_h == true:
		animation_player.play("attack_left")
		
func make_damage():
	if enemies_in_range.size() > 0:
		for enemy in enemies_in_range:
			enemy.take_damage(damage, self_attack_direction, self_knockback_force)
		in_colldown = true
		
func _on_weapon_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		enemies_in_range.append(body)
		
func _on_weapon_collision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		enemies_in_range.erase(body)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if ["attack_right", "attack_left"].has(anim_name):
		is_attack = false
		in_colldown = false
