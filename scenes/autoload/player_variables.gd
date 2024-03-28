extends Node

var current_health: int
var max_health: int
var steel: int = 0


func _ready():
	GameEvents.steel_collected.connect(on_steel_collected)
	
	
func on_steel_collected(value: int):
	steel += value
