extends Node

signal character_switched(name: Constants.CharacterNames)

var members: Array[Player] = []
var member_scenes: Array[PackedScene] = []
var active_member_index: int = -1
var is_holding: bool = false
var is_switch_character_disabled: bool = false

@onready var april_scene: PackedScene = preload("res://scenes/entities/players/april.tscn")
@onready var cube_scene: PackedScene = preload("res://scenes/entities/players/cube.tscn")
@onready var scene_dictionary = {
	Constants.CharacterNames.APRIL: april_scene,
	Constants.CharacterNames.CUBE: cube_scene
}


func _unhandled_input(event):
	if Input.is_action_just_pressed("switch_character"):
		get_tree().root.set_input_as_handled()
		switch_character()
	elif event.is_action_pressed("toggle_hold"):
		get_tree().root.set_input_as_handled()
		toggle_hold()


func add_member(node: Player):
	if not members.has(node):
		members.append(node)
	
	if members.size() == 1:
		active_member_index = 0
		node.state_machine.transition_to("Active")
	else:
		node.state_machine.transition_to("Follow")
	
	if not member_scenes.has(scene_dictionary[node.character_name]):
		member_scenes.append(scene_dictionary[node.character_name])


func remove_member(node: Player):
	members.erase(node)
	if members.size() == 0:
		active_member_index = -1


func clear_members():
	members.clear()
	active_member_index = -1


func remove_member_scene(node: Player):
	member_scenes.erase(scene_dictionary[node.character_name])


func has_member(member_name: Constants.CharacterNames) -> bool:
	return member_scenes.has(scene_dictionary[member_name])


func get_active_member() -> Player:
	if active_member_index == -1 or active_member_index > members.size() - 1:
		return
	return members[active_member_index]


func instantiate_party(position: Vector2, active_member_name: Constants.CharacterNames):
	is_holding = false
	var entities_layer = get_tree().get_first_node_in_group("entities")
	for n in member_scenes.size():
		var party_member = member_scenes[n].instantiate()
		entities_layer.add_child(party_member)
		party_member.global_position = position
		
		if party_member.character_name == active_member_name:
			party_member.state_machine.transition_to("Active")
			active_member_index = n
		else:
			party_member.state_machine.transition_to("Follow")


func switch_character():
	if is_switch_character_disabled:
		return
	
	var next_active_member_index = active_member_index + 1
	if next_active_member_index > members.size() - 1:
		next_active_member_index = 0
	
	var next_active_member = members[next_active_member_index]
	next_active_member.state_machine.transition_to("Active")
	
	active_member_index = next_active_member_index
	
	for i in range(members.size()):
		if i == next_active_member_index:
			continue
		
		if is_holding:
			members[i].state_machine.transition_to("Hold")
		else:
			members[i].state_machine.transition_to("Follow")
	
	character_switched.emit(next_active_member.character_name)


func toggle_hold():
	is_holding = !is_holding
		
	for i in range(members.size()):
		if i == active_member_index:
			continue
			
		if is_holding:
			members[i].state_machine.transition_to("Hold")
		else:
			members[i].state_machine.transition_to("Follow")


func rubberband_party():
	var new_position = get_active_member().global_position
	
	for i in range(members.size()):
		if i == active_member_index:
			continue
		
		if members[i].global_position.distance_to(new_position) > 16:
			members[i].global_position = new_position


func disable_switch_character(value):
	is_switch_character_disabled = value
