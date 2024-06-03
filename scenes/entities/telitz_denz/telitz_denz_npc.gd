extends Npc

@export_enum("telitz_denz_1", "telitz_denz_2", "telitz_denz_3") var conversation_id: String
@onready var animation_tree: AnimationTree = $AnimationTree


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(conversation_id):
		EntityVariables.conversations[conversation_id] = { "interacted": false }


func update_blend_position(direction: Vector2):
	animation_tree["parameters/idle/BlendSpace2D/blend_position"] = direction
	animation_tree["parameters/walk/BlendSpace2D/blend_position"] = direction


func on_interact():
	pass
