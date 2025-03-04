extends Node2D
class_name OverworldPlane

signal plane_changed(next_plane: PackedScene)

@onready var animation_player = $AnimationPlayer
@onready var tile_map_layers = $TileMapLayers


func _ready():
	var ladders: Array[Node] = get_tree().get_nodes_in_group("ladders")
	for ladder in ladders:
		ladder.ladder_activated.connect(on_ladder_activated)


func is_cell_walkable(map_position: Vector2i) -> bool:
	return tile_map_layers.is_cell_walkable(map_position)


func map_to_global(map_position: Vector2i) -> Vector2:
	return tile_map_layers.map_to_global(map_position)


func exit():
	# calls queue_free()
	animation_player.play("fly_away")


func enter():
	animation_player.play("fade_in")


func on_ladder_activated(next_plane: PackedScene):
	plane_changed.emit(next_plane)
