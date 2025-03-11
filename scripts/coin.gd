extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var tween_position = get_tree().create_tween()
		var tween_transparency = get_tree().create_tween()
		tween_position.tween_property(self, "position", position - Vector2(0, 25), 0.3)
		tween_transparency.tween_property(self, "modulate:a", 0, 0.5)
		body.current_gold += 1
		tween_position.tween_callback(queue_free)
