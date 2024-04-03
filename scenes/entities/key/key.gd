extends Node2D

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	
func on_interact():
	print("on_interact")
