extends Node

var members: Array[Player] = []
var active_member_index: int = -1
var is_holding: bool = false


func _unhandled_input(event):
	if event.is_action_pressed("switch_character"):
		switch_character()
	elif event.is_action_pressed("toggle_hold"):
		toggle_hold()


func add_member(node: Player):
	members.append(node)
	if members.size() == 1:
		active_member_index = 0


func get_active_member() -> Player:
	return members[active_member_index]


func switch_character():
	var next_active_member_index = active_member_index + 1
	if next_active_member_index > members.size() - 1:
		next_active_member_index = 0
	
	var next_active_member = members[next_active_member_index]
	next_active_member.state_machine.transition_to("Active")
	
	for i in range(members.size()):
		if i == next_active_member_index:
			continue
		
		if is_holding:
			members[i].state_machine.transition_to("Hold")
		else:
			members[i].state_machine.transition_to("Follow")


func toggle_hold():
	is_holding = !is_holding
		
	for i in range(members.size()):
		if i == active_member_index:
			continue
			
		if is_holding:
			members[i].state_machine.transition_to("Hold")
		else:
			members[i].state_machine.transition_to("Follow")
