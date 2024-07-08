extends RayCast2D

const FLOOR_1: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.ONE]
const FLOOR_2: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.TWO]
const FLOOR_3: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.THREE]
const FLOOR_4: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.FOUR]


func _ready():
	GameEvents.player_elevation_changed.connect(on_player_elevation_changed)


func on_player_elevation_changed(elevation: Constants.Elevations):
	match elevation:
		Constants.Elevations.ONE:
			set_collision_mask_value(FLOOR_1, false)
			set_collision_mask_value(FLOOR_2, true)
			set_collision_mask_value(FLOOR_3, false)
			set_collision_mask_value(FLOOR_4, false)
		Constants.Elevations.TWO:
			set_collision_mask_value(FLOOR_1, false)
			set_collision_mask_value(FLOOR_2, false)
			set_collision_mask_value(FLOOR_3, true)
			set_collision_mask_value(FLOOR_4, false)
		Constants.Elevations.THREE:
			set_collision_mask_value(FLOOR_1, false)
			set_collision_mask_value(FLOOR_2, false)
			set_collision_mask_value(FLOOR_3, false)
			set_collision_mask_value(FLOOR_4, true)
