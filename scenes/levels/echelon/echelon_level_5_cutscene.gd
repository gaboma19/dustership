extends Node

@onready var chest = %Chest



func _ready():
	chest.opened.connect(on_chest_opened)
	await get_tree().create_timer(0.4).timeout
	var player: Player = PartyManager.get_active_member()
	player.update_blend_position(Vector2.UP)


func on_chest_opened():
	# player.speak(LINES)
	pass
