extends Node

signal died

var max_health: int = 3
var current_health: int = max_health
var steel: int = 0
var pause_menu_screen: int = 0
var enable_game_start: bool = true
var has_sword: bool = false
var has_gun: bool = true
var is_april_active: bool = true
var is_telitz_active: bool = false


func _ready():
	current_health = max_health
	
	GameEvents.steel_collected.connect(on_steel_collected)
	HealthBar.set_hearts()


func heal(heal_amount: int):
	if current_health == max_health:
		return
	
	current_health = min(current_health + heal_amount, max_health)
	GameEvents.emit_player_healed()


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	GameEvents.emit_player_damaged()
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0:
		died.emit()


func restart_game():
	current_health = max_health
	steel = 0
	HealthBar.set_hearts()
	SteelCounter.set_counter()


func save_data() -> Dictionary:
	var data = {
		"current_health" = current_health,
		"max_health" = max_health,
		"steel" = steel,
		"pause_menu_screen" = pause_menu_screen,
		"has_sword" = has_sword,
		"has_gun" = has_gun,
		"is_april_active" = is_april_active,
		"is_telitz_active" = is_telitz_active
	}
	return data


func load_data(data: Dictionary):
	current_health = data["current_health"]
	max_health = data["max_health"]
	steel = data["steel"]
	pause_menu_screen = data["pause_menu_screen"]
	has_sword = data["has_sword"]
	has_gun = data["has_gun"]
	is_april_active = data["is_april_active"]
	is_telitz_active = data["is_telitz_active"]


func on_steel_collected(value: int):
	steel += value
