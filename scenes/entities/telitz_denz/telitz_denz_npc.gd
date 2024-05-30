extends Npc

@export_enum("telitz_denz_1", "telitz_denz_2", "telitz_denz_3") var conversation_id: String


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(conversation_id):
		EntityVariables.conversations[conversation_id] = { "interacted": false }


func on_interact():
	pass
