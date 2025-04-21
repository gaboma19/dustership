extends Node2D

const OVERWORLD_SEVERE = preload("res://assets/overworld/overworld_severe.png")
const OVERWORLD_MODERATE = preload("res://assets/overworld/overworld_moderate.png")
const OVERWORLD_MILD = preload("res://assets/overworld/overworld_mild.png")
const OVERWORLD_GREEN = preload("res://assets/overworld/overworld_none.png")

@export var player_position: Vector2 = Vector2.ZERO
@export var dungeon_id: String
@export var dungeon_detail_scene: PackedScene
@export var location_name: String
@export var infection_level: Constants.InfectionLevel

var dungeon_detail: AnimatedPanel

@onready var player_detector_area: Area2D = $PlayerDetectorArea
@onready var indicator_detector_area: Area2D = $IndicatorDetectorArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var detail_container = %DetailContainer
@onready var icon_sprite: Sprite2D = $IconSprite


func _ready():
	if OverworldVariables.dungeons.has(dungeon_id):
		set_active(OverworldVariables.dungeons[dungeon_id].active)
	else:
		OverworldVariables.dungeons[dungeon_id] = { "active": true }
		set_active(true)
	
	set_icon()
	
	player_detector_area.area_entered.connect(on_player_detected)
	player_detector_area.area_exited.connect(on_player_exited)
	indicator_detector_area.area_entered.connect(on_indicator_detected)
	indicator_detector_area.area_exited.connect(on_indicator_exited)


func set_active(value: bool):
	set_visible(value)
	player_detector_area.call_deferred("set_monitoring", value)


func set_icon():
	match infection_level:
		Constants.InfectionLevel.NONE:
			icon_sprite.texture = OVERWORLD_GREEN
		Constants.InfectionLevel.MILD:
			icon_sprite.texture = OVERWORLD_MILD
		Constants.InfectionLevel.MODERATE:
			icon_sprite.texture = OVERWORLD_MODERATE
		Constants.InfectionLevel.SEVERE:
			icon_sprite.texture = OVERWORLD_SEVERE


func on_player_detected(_player_component: Area2D):
	var player: OverworldPlayer = OverworldVariables.player
	player.state_machine.transition_to("Hold")
	
	animation_player.play("hide_icon")
	await get_tree().create_timer(0.3).timeout
	
	OverworldVariables.dungeons[dungeon_id].active = false
	
	enter_dungeon()


func on_player_exited(_player_component: Area2D):
	animation_player.play_backwards("hide_icon")


func on_indicator_detected(_area: Area2D):
	open_detail()


func on_indicator_exited(_area: Area2D):
	dungeon_detail.close()


func open_detail():
	var canvas_pos = get_global_transform_with_canvas().origin
	
	dungeon_detail = dungeon_detail_scene.instantiate()
	dungeon_detail.location_name = location_name
	detail_container.add_child(dungeon_detail)
	
	await detail_container.resized
	
	canvas_pos.x -= detail_container.size.x / 2
	canvas_pos.y -= 72
	detail_container.position = canvas_pos
	
	dungeon_detail.open()


func enter_dungeon():
	DungeonManager.create()
	var room: Room = DungeonManager.get_room(Vector2i.ZERO)
	var scene_path = room.scene_path
	
	if scene_path.is_empty():
		set_active(false)
		return
	
	await get_tree().create_timer(0.15).timeout
	
	var active_member_name = Constants.CharacterNames.APRIL
	ScreenTransition.transition_to_dungeon_level(
		scene_path, player_position, active_member_name, room, false)
