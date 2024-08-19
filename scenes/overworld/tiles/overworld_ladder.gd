extends Sprite2D

@export var next_layer: PackedScene

@onready var layer: TileMap = get_parent()
@onready var player_detector_area = $PlayerDetectorArea


func _ready():
	player_detector_area.area_entered.connect(on_player_detected)


func on_player_detected(player_component: Area2D):
	var player: OverworldPlayer = player_component.get_parent()
	player.exit()
	layer.exit()
