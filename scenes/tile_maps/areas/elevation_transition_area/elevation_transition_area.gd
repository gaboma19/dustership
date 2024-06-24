extends Area2D

const FLOOR_1: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.ONE]
const FLOOR_2: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.TWO]
const FLOOR_3: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.THREE]
const FLOOR_4: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.FOUR]

@export_enum("One", "Two", "Three") var elevation: String


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	var player = body as Player
	
	match elevation:
		"One":
			GameEvents.emit_player_elevation_changed(Constants.Elevations.ONE)
			player.set_collision_mask_value(FLOOR_1, true)
			player.set_collision_mask_value(FLOOR_2, true)
			player.set_collision_mask_value(FLOOR_3, false)
			player.set_collision_mask_value(FLOOR_4, false)
		"Two":
			GameEvents.emit_player_elevation_changed(Constants.Elevations.TWO)
			player.set_collision_mask_value(FLOOR_1, false)
			player.set_collision_mask_value(FLOOR_2, true)
			player.set_collision_mask_value(FLOOR_3, true)
			player.set_collision_mask_value(FLOOR_4, false)
		"Three":
			GameEvents.emit_player_elevation_changed(Constants.Elevations.THREE)
			player.set_collision_mask_value(FLOOR_1, false)
			player.set_collision_mask_value(FLOOR_2, false)
			player.set_collision_mask_value(FLOOR_3, true)
			player.set_collision_mask_value(FLOOR_4, true)
