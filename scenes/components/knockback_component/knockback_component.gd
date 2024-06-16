extends Node2D
class_name KnockbackComponent

const FLOOR_1: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.ONE]
const FLOOR_2: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.TWO]
const FLOOR_3: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.THREE]
const FLOOR_4: int = Constants.ELEVATION_COLLISION_LAYERS[Constants.Elevations.FOUR]

var direction: Vector2

@onready var wall_detector: Area2D = $WallDetector
@onready var floor_detector: Area2D = $FloorDetector


func _ready():
	GameEvents.player_elevation_changed.connect(on_player_elevation_changed)


func on_player_elevation_changed(elevation: Constants.Elevations):
	match elevation:
		Constants.Elevations.ONE:
			wall_detector.set_collision_mask_value(FLOOR_1, false)
			wall_detector.set_collision_mask_value(FLOOR_2, true)
			wall_detector.set_collision_mask_value(FLOOR_3, false)
			wall_detector.set_collision_mask_value(FLOOR_4, false)
			
			floor_detector.set_collision_mask_value(FLOOR_1, true)
			floor_detector.set_collision_mask_value(FLOOR_2, false)
			floor_detector.set_collision_mask_value(FLOOR_3, false)
			floor_detector.set_collision_mask_value(FLOOR_4, false)
		Constants.Elevations.TWO:
			wall_detector.set_collision_mask_value(FLOOR_1, false)
			wall_detector.set_collision_mask_value(FLOOR_2, false)
			wall_detector.set_collision_mask_value(FLOOR_3, true)
			wall_detector.set_collision_mask_value(FLOOR_4, false)
			
			floor_detector.set_collision_mask_value(FLOOR_1, false)
			floor_detector.set_collision_mask_value(FLOOR_2, true)
			floor_detector.set_collision_mask_value(FLOOR_3, false)
			floor_detector.set_collision_mask_value(FLOOR_4, false)
		Constants.Elevations.THREE:
			wall_detector.set_collision_mask_value(FLOOR_1, false)
			wall_detector.set_collision_mask_value(FLOOR_2, false)
			wall_detector.set_collision_mask_value(FLOOR_3, false)
			wall_detector.set_collision_mask_value(FLOOR_4, true)
			
			floor_detector.set_collision_mask_value(FLOOR_1, false)
			floor_detector.set_collision_mask_value(FLOOR_2, false)
			floor_detector.set_collision_mask_value(FLOOR_3, true)
			floor_detector.set_collision_mask_value(FLOOR_4, false)
