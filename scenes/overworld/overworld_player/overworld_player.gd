extends Sprite2D
class_name OverworldPlayer

var is_moving: bool = false
var selected_tile: Vector2i

@onready var animation_player = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var overworld_indicator_tile = $OverworldIndicatorTile
@onready var mouse_detectors = $MouseDetectors


func _ready():
	show()
	animation_player.play("enter")
	OverworldVariables.player = self
	selected_tile = OverworldVariables.player_map_position


func set_is_moving(value: bool):
	is_moving = value


func move(vector: Vector2i):
	if OverworldVariables.active_plane == null:
		return
	
	var active_plane = OverworldVariables.active_plane
	var new_cell = OverworldVariables.player_map_position + vector
	
	if active_plane.is_cell_walkable(new_cell):
		var new_position = active_plane.map_to_global(new_cell)
		
		set_is_moving(true)
		var tween = create_tween()
		tween.tween_property(self, "global_position", new_position, 0.2)
		tween.tween_callback(set_is_moving.bind(false))
		
		OverworldVariables.player_map_position = new_cell


func select(vector: Vector2i):
	if OverworldVariables.active_plane == null:
		return
	
	var active_plane = OverworldVariables.active_plane
	var new_cell = OverworldVariables.player_map_position + vector
	
	selected_tile = new_cell
	var indicator_position = active_plane.map_to_global(new_cell)
	overworld_indicator_tile.global_position = indicator_position


func select_keyboard(vector: Vector2i):
	if OverworldVariables.active_plane == null:
		return
	
	var map_position = OverworldVariables.player_map_position
	var allowed_cells = [
		map_position,
		map_position + Vector2i.UP,
		map_position + Vector2i.DOWN,
		map_position + Vector2i.LEFT,
		map_position + Vector2i.RIGHT
	]
	
	var active_plane = OverworldVariables.active_plane
	var new_cell = selected_tile + vector
	
	if new_cell not in allowed_cells:
		return
	
	selected_tile = new_cell
	var indicator_position = active_plane.map_to_global(new_cell)
	overworld_indicator_tile.global_position = indicator_position


func exit():
	animation_player.play("exit")
	await get_tree().create_timer(0.6).timeout
	queue_free()
