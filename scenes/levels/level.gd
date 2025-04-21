extends Node2D
class_name Level

@export var is_camera_static = false
@export var map_pin_cell: Vector2i
@export var game_start: Node2D
@export var entrance_points: Array[Node2D]

var end_screen_scene = preload("res://scenes/ui/end_screen/end_screen.tscn")
var pause_screen_scene = preload("res://scenes/ui/pause_screen/pause_screen.tscn")
var player: Player

@onready var game_camera = $GameCamera


func _ready():
	PlayerVariables.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		var pause_screen = pause_screen_scene.instantiate()
		pause_screen.map_pin_cell = map_pin_cell
		add_child(pause_screen)


func set_player_position(
	end_position: Vector2, active_member_name: Constants.CharacterNames):
	
	var entrance_node = pick_entrance_point(end_position)
	var start_position
	if entrance_node != null:
		start_position = entrance_node.global_position
	else:
		start_position = end_position
	
	set_level_transitions_monitoring(false)
	
	PartyManager.instantiate_party(start_position, active_member_name)
	player = PartyManager.get_active_member()
	
	player.state_machine.transition_to("Hold")
	
	await get_tree().create_timer(ScreenTransition.ANIMATION_LENGTH).timeout
	
	var velocity_component: VelocityComponent = player.velocity_component
	velocity_component.arrived.connect(on_player_arrived)
	velocity_component.process_accelerate_to_point(end_position)
	
	if not is_camera_static:
		game_camera.global_position = start_position
		game_camera.reset_smoothing()


func on_player_arrived():
	set_level_transitions_monitoring(true)
	player.state_machine.transition_to("Active")


# used in ScreenTransition.restart_game()
func set_player_at_game_start(active_member_name: Constants.CharacterNames):
	var player_position = game_start.global_position
	
	PartyManager.instantiate_party(player_position, active_member_name)
	
	if not is_camera_static:
		game_camera.global_position = player_position
		game_camera.reset_smoothing()


func pick_entrance_point(final_position: Vector2) -> Node2D:
	if entrance_points.is_empty():
		return null
	if entrance_points.size() == 1:
		return entrance_points[0]
	
	var closest_point: Node2D
	var shortest_distance: float
	
	for point in entrance_points:
		var distance = point.global_position.distance_to(final_position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_point = point
	
	return closest_point


func set_level_transitions_monitoring(value: bool):
	var transitions: Array[Node] = get_tree().get_nodes_in_group("transition_area")
	for transition in transitions:
		var area2d = transition as Area2D
		if area2d:
			area2d.set_monitoring(value)


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.level_file_path = scene_file_path
	end_screen_instance.set_defeat()
