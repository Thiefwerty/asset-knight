extends ChasingEnemy

func _ready():
	super._ready()
	self_knockback_force = Vector2(200, -10)
