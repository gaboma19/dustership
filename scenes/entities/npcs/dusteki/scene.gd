# npcs/dusteki/scene.gd
extends State

@onready var dusteki = owner as Npc


func enter(_msg := {}) -> void:
	var player = PartyManager.get_active_member()
	if player == null:
		return
	
	var direction = dusteki.global_position.direction_to(player.global_position)
	dusteki.update_blend_position(direction)
	
	dusteki.speak(["Lorem ipsum dolor sit emet."])
