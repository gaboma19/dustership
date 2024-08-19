extends Sprite2D

signal ladder_activated(next_layer: PackedScene)

@export var next_layer: PackedScene

@onready var layer: TileMap = get_parent()
@onready var player_detector_area = $PlayerDetectorArea


func _ready():
	player_detector_area.area_entered.connect(on_player_detected)


func on_player_detected(_player_component: Area2D):
	ladder_activated.emit(next_layer)
