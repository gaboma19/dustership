extends Sprite2D

signal ladder_activated(next_layer: PackedScene)

@export var next_layer: PackedScene

@onready var layer: TileMap = get_parent()
@onready var player_detector_area = $PlayerDetectorArea
@onready var animation_player = $AnimationPlayer


func _ready():
	player_detector_area.area_entered.connect(on_player_detected)


func open():
	animation_player.play("default")


func on_player_detected(_player_component: Area2D):
	open()
	await get_tree().create_timer(1.3).timeout
	ladder_activated.emit(next_layer)
