# telitz_denz_ambush.gd
extends State

@export var ambush_range_area: Area2D

@onready var telitz_denz = owner as Npc


func enter(_msg := {}) -> void:
	telitz_denz.hide()
	ambush_range_area.body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if not EntityVariables.conversations[telitz_denz.conversation_id].interacted:
		EntityVariables.conversations[telitz_denz.conversation_id].interacted = true
	else:
		return
	
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	ambush_range_area.body_entered.disconnect(on_body_entered)
	state_machine.transition_to("Spawn")
