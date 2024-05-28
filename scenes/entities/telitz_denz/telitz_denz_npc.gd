extends Npc

const LINES_1: Array[String] = [
	"Hello, April."
]

const INTERACTED_LINES_1: Array[String] = [
	"Hello, April."
]

@export_enum("telitz_denz_1", "telitz_denz_2", "telitz_denz_3") var conversation_id: String


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(conversation_id):
		EntityVariables.conversations[conversation_id] = { "interacted": false }


func on_interact():
	var april = PartyManager.get_april()
	
	if not EntityVariables.conversations[conversation_id].interacted:
		EntityVariables.conversations[conversation_id].interacted = true
		self.speak(LINES_1)
	else:
		self.speak(INTERACTED_LINES_1)
