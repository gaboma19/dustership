extends Node

@onready var label = %Label

var active_areas = []
var can_interact = true


func register_area(area: InteractionArea):
	active_areas.push_back(area)


func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(_delta):
	if active_areas.size() > 0 && can_interact && !DialogueManager.is_dialogue_active:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = active_areas[0].action_name
		label.show()
	else:
		label.hide()


func _sort_by_distance_to_player(area1, area2):
	var player = PartyManager.get_active_member() as Player
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		get_tree().root.set_input_as_handled()
		if can_interact && active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
