extends Node

@export var interaction_detail_scene: PackedScene

var active_areas = []
var can_interact = true
var interaction_detail: AnimatedPanel

@onready var detail_container = %DetailContainer


func register_area(area: InteractionArea):
	active_areas.push_back(area)


func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(_delta):
	if (
		active_areas.size() > 0 
		and can_interact 
		and !DialogueManager.is_dialogue_active
	):
		active_areas.sort_custom(_sort_by_distance_to_player)
		if interaction_detail == null:
			open(active_areas[0])
	else:
		close()


func open(area: InteractionArea):
	var parent = area.get_parent()
	var canvas_pos = parent.get_global_transform_with_canvas().origin
	
	interaction_detail = interaction_detail_scene.instantiate()
	interaction_detail.action_name = area.action_name
	detail_container.add_child(interaction_detail)
	
	#await detail_container.resized
	
	canvas_pos.x -= detail_container.size.x / 2
	canvas_pos.y -= 96
	detail_container.position = canvas_pos
	
	interaction_detail.open()


func close():
	if interaction_detail != null:
		interaction_detail.close()
		interaction_detail = null


func _sort_by_distance_to_player(area1, area2):
	var player = PartyManager.get_active_member() as Player
	if player == null:
		return
	
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		get_tree().root.set_input_as_handled()
		if can_interact && active_areas.size() > 0:
			can_interact = false
			close()
			
			await active_areas[0].interact.call()
			
			can_interact = true
