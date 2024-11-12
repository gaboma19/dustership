extends Sprite2D

@export var player_position: Vector2 = Vector2.ZERO
@export var ingress_id: String
@export var dungeon_warning_scene: PackedScene

@onready var interaction_area = $InteractionArea
@onready var overworld_ui = %OverworldUI
@onready var player_detector_area = $PlayerDetectorArea
@onready var animation_player = $AnimationPlayer


func _ready():
	if OverworldVariables.ingresses.has(ingress_id):
		set_active(OverworldVariables.ingresses[ingress_id].active)
	else:
		OverworldVariables.ingresses[ingress_id] = { "active": true }
		set_active(true)
	
	interaction_area.interact = Callable(self, "on_interact")
	player_detector_area.area_entered.connect(on_player_detected)
	player_detector_area.area_exited.connect(on_player_exited)


func set_active(value: bool):
	set_visible(value)
	interaction_area.call_deferred("set_monitoring", value)


func on_player_detected(_player_component: Area2D):
	animation_player.play("fade_out")


func on_player_exited(_player_component: Area2D):
	animation_player.play_backwards("fade_out")


func on_interact(player_component: Area2D):
	OverworldVariables.ingresses[ingress_id].active = false
	
	var player = player_component.get_parent()
	player.state_machine.transition_to("Hold")
	
	var dungeon_warning = dungeon_warning_scene.instantiate()
	dungeon_warning.continue_pressed.connect(on_continue)


func on_continue():
	DungeonManager.create()
	var room: Room = DungeonManager.get_room(Vector2i.ZERO)
	var scene_path = room.scene_path
	
	if scene_path.is_empty():
		set_active(false)
		return
	
	var active_member_name = Constants.CharacterNames.APRIL
	ScreenTransition.transition_to_dungeon_level(
		scene_path, player_position, active_member_name, room)
