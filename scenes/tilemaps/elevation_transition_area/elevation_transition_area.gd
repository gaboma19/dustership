extends Area2D

const floor_1: int = 6
const floor_2: int = 10
const floor_3: int = 11
const floor_4: int = 13

@export_enum("One", "Two", "Three") var elevation: String


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	var player = body as Player
	
	match elevation:
		"One":
			player.set_collision_mask_value(floor_1, true)
			player.set_collision_mask_value(floor_2, true)
			player.set_collision_mask_value(floor_3, false)
			player.set_collision_mask_value(floor_4, false)
		"Two":
			player.set_collision_mask_value(floor_1, false)
			player.set_collision_mask_value(floor_2, true)
			player.set_collision_mask_value(floor_3, true)
			player.set_collision_mask_value(floor_4, false)
		"Three":
			player.set_collision_mask_value(floor_1, false)
			player.set_collision_mask_value(floor_2, false)
			player.set_collision_mask_value(floor_3, true)
			player.set_collision_mask_value(floor_4, true)
