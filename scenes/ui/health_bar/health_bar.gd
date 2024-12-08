extends CanvasLayer

@export var heart_panel_scene: PackedScene
@export var empty_heart_panel_scene: PackedScene

@onready var heart_container: HBoxContainer = %HeartContainer
@onready var portrait_texture = %PortraitTexture
@onready var steel_label = %SteelLabel
@onready var bytes_progress_bar = %BytesProgressBar
@onready var hud: CanvasLayer = get_parent()


func _ready():
	GameEvents.player_damaged.connect(on_player_damaged)
	GameEvents.player_healed.connect(on_player_healed)
	PartyManager.character_switched.connect(on_character_switched)
	PartyManager.character_activated.connect(on_character_activated)
	GameEvents.steel_collected.connect(on_currency_collected)
	GameEvents.bytes_gained.connect(on_currency_collected)
	hud.visibility_changed.connect(on_visibility_changed)
	
	clear_hearts()
	set_counter()


func set_counter():
	steel_label.text = format_number(PlayerVariables.steel)
	bytes_progress_bar.value = PlayerVariables.bytes


func clear_hearts():
	for heart in heart_container.get_children():
		heart.queue_free()


func set_hearts():
	clear_hearts()
	
	for i in PlayerVariables.current_health:
		var heart_container_instance = heart_panel_scene.instantiate()
		heart_container.add_child(heart_container_instance)
		
	for j in PlayerVariables.max_health - PlayerVariables.current_health:
		var empty_heart_container_instance = empty_heart_panel_scene.instantiate()
		heart_container.add_child(empty_heart_container_instance)


func set_portrait(character_name: Constants.CharacterNames):
	match character_name:
		Constants.CharacterNames.APRIL:
			portrait_texture.texture = preload("res://assets/april/april_portrait.png")
		Constants.CharacterNames.CUBE:
			portrait_texture.texture = preload("res://assets/cube/cube_portrait.png")
		Constants.CharacterNames.TELITZ:
			portrait_texture.texture = preload("res://assets/telitz_denz/telitz_portrait.png")


func format_number(value) -> String:
	value = str(round(value))
	var output := ""
	
	for i in range(value.length()):
		if i != 0 and i % 3 == value.length() % 3:
			output += ","
		output += value[i]
	
	return output


func on_currency_collected(_value):
	set_counter()


func on_player_damaged():
	set_hearts()


func on_player_healed():
	set_hearts()


func on_character_switched(character_name: Constants.CharacterNames):
	set_portrait(character_name)


func on_character_activated(character_name: Constants.CharacterNames):
	set_portrait(character_name)


func on_visibility_changed():
	visible = hud.visible
