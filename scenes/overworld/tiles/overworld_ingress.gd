extends Sprite2D

@export var scene_path: String
@export var ingress_id: String

@onready var player_detector_area = $PlayerDetectorArea


func _ready():
	if OverworldVariables.ingresses.has(ingress_id):
		set_active(OverworldVariables.ingresses[ingress_id].active)
	else:
		OverworldVariables.ingresses[ingress_id] = { "active": true }
		set_active(true)
	
	player_detector_area.area_entered.connect(on_player_entered)


func set_active(value: bool):
	set_visible(value)
	player_detector_area.call_deferred("set_monitoring", value)


func on_player_entered(_player_component: Area2D):
	OverworldVariables.ingresses[ingress_id].active = false
	
	ScreenTransition.transition_out()
	await get_tree().create_timer(0.4).timeout
	
	set_active(false)
	if not scene_path.is_empty():
		get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	ScreenTransition.transition_in()
