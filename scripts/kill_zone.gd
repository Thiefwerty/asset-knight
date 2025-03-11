extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !body.is_dead:
		Engine.time_scale = 0.5
		body.is_dead = true
