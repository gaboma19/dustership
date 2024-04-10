extends Node

signal died

var current_health: int
var max_health: int = 3
var steel: int = 0
var pause_menu_screen: int = 0


func _ready():
	current_health = max_health
	
	GameEvents.steel_collected.connect(on_steel_collected)
	HealthBar.set_hearts()


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	GameEvents.emit_player_damaged()
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()


func on_steel_collected(value: int):
	steel += value
