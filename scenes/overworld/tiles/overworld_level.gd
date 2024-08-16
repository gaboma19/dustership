extends Sprite2D

@export var scene_path: String

@onready var level_transition_area = $LevelTransitionArea


func _ready():
	level_transition_area.area_entered.connect(on_player_entered)


func deactivate():
	hide()
	level_transition_area.call_deferred("set_monitoring", false)


func on_player_entered(_player_component: Area2D):
	ScreenTransition.transition_out()
	
	await get_tree().create_timer(0.4).timeout
	deactivate()
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	ScreenTransition.transition_in()
