extends Area2D

const floor_1: int = 6
const floor_2: int = 10
const floor_3: int = 11

@export_enum("One", "Two", "Three") var elevation: int


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	var player = body as Player
	
	match elevation:
		0:
			player.set_collision_mask_value(floor_1, true)
			player.set_collision_mask_value(floor_2, true)
			player.set_collision_mask_value(floor_3, false)
		1:
			player.set_collision_mask_value(floor_1, false)
			player.set_collision_mask_value(floor_2, true)
			player.set_collision_mask_value(floor_3, true)
		2:
			player.set_collision_mask_value(floor_1, false)
			player.set_collision_mask_value(floor_2, false)
			player.set_collision_mask_value(floor_3, true)
