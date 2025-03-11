extends ParallaxBackground


const SPEED = 25

func _process(delta: float) -> void:
	scroll_offset.x -= SPEED * delta
