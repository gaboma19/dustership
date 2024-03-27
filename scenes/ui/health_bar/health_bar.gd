extends CanvasLayer

@export var heart_panel_scene: PackedScene

@onready var heart_container: HBoxContainer = %HeartContainer


func _ready():
	GameEvents.player_damaged.connect(on_player_damaged)
	clear_hearts()
		
		
func clear_hearts():
	for heart in heart_container.get_children():
		heart.queue_free()


func set_hearts():
	clear_hearts()
	
	for i in PlayerVariables.current_health:
		var heart_container_instance = heart_panel_scene.instantiate()
		heart_container.add_child(heart_container_instance)
		
	for j in PlayerVariables.max_health - PlayerVariables.current_health:
		pass
	
	
func on_player_damaged():
	set_hearts()
