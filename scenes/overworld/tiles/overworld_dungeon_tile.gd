extends Sprite2D

@export var player_position: Vector2
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
	
	LevelManager.create_dungeon()
	var room: Room = LevelManager.get_room(Vector2i.ZERO)
	var scene_path = room.scene_path
	
	if scene_path.is_empty():
		set_active(false)
		return
	
	var active_member_name = Constants.CharacterNames.APRIL
	ScreenTransition.transition_to_dungeon_level(
		scene_path, player_position, active_member_name, room)
