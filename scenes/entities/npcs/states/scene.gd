# npcs/dusteki/scene.gd
extends State

var speak_count: int = 0

@onready var npc = owner as Npc


func enter(_msg := {}) -> void:
	var player = PartyManager.get_active_member()
	if player == null:
		return
	
	var direction = npc.global_position.direction_to(player.global_position)
	npc.update_blend_position(direction)
	
	var index = speak_count % npc.lines.size()
	var current_line: Array[String] = [npc.lines[index] as String]
	npc.speak(current_line)
	
	speak_count += 1
