extends CanvasLayer

@onready var player = get_parent().get_node("Player")
@onready var hp_label = get_child(0)
@onready var gold_label = get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_hp = player.current_hp
	var player_gold = player.current_gold
	hp_label.text = "HP: " + str(player_hp)
	gold_label.text = "Gold: " + str(player_gold)
