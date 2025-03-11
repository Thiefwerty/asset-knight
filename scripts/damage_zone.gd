extends Area2D

@onready var enemy = get_parent()

var damage: int 
var attack_direction: Vector2
var knockback_force: Vector2

func _on_body_entered(body: Node2D) -> void:
	damage = enemy.damage
	attack_direction = enemy.self_attack_direction
	knockback_force= enemy.self_knockback_force
	if body.name == "Player" and !enemy.is_dead():
		body.take_damage(damage, attack_direction, knockback_force)
