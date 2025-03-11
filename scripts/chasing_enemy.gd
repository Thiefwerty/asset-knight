extends Enemy
class_name ChasingEnemy


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../../Player"

@export var patrol_range: float = 40
@export var chase_radius: float = 60

var patrol_direction: int = 1
var is_chase: bool = false #меняется в ChaseZone

var initial_position: Vector2


func _ready() -> void:
	super._ready()
	initial_position = global_position

func _physics_process(delta: float) -> void:
	
	super._physics_process(delta)
	
	if is_chase:
		chase()
	else:
		patrol()
	
func chase():
	var player_position = player.global_position
	if player_position:
		direction = (player_position - global_position).normalized()
	else:
		direction = Vector2.ZERO
	
func patrol():
	var target_position = initial_position + Vector2(patrol_range * patrol_direction, 0)
	
	if global_position.distance_to(target_position) < 1.0:
		patrol_direction *= -1
		
	direction = (target_position - global_position).normalized()
