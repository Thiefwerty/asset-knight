extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var enemy = get_parent()

func _ready() -> void:
	collision_shape_2d.shape.radius = enemy.chase_radius

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		enemy.is_chase = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		enemy.is_chase = false
