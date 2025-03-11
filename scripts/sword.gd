extends WeaponBase


func _ready():
	super._ready()
	damage = 10
	attack_speed = 4
	self_knockback_force = Vector2(100, -10)
	
func _process(delta: float) -> void:
	super._process(delta)
	
func attack():
	super.attack()
