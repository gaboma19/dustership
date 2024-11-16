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

@onready var player_detector_area: Area2D = $PlayerDetectorArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var overworld_ui: Control = %OverworldUI
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


func open_detail():
	OverworldVariables.dungeons[dungeon_id].active = false
	
	animation_player.play("dim")
	
	var dungeon_detail = dungeon_detail_scene.instantiate()
	dungeon_detail.canceled.connect(on_detail_canceled)
	dungeon_detail.continued.connect(on_detail_continued)
	dungeon_detail.location_name = location_name
	dungeon_detail.infection_level = infection_level
	overworld_ui.add_child(dungeon_detail)


func on_player_detected(_player_component: Area2D):
	var player: OverworldPlayer = OverworldVariables.player
	player.state_machine.transition_to("Hold")
	
	animation_player.play("hide_icon")
	await get_tree().create_timer(0.3).timeout
	
	open_detail()


func on_player_exited(_player_component: Area2D):
	animation_player.play_backwards("hide_icon")


func on_detail_canceled():
	animation_player.play_backwards("dim")
	
	var player: OverworldPlayer = OverworldVariables.player
	player.move(OverworldVariables.previous_map_position)
	
	await get_tree().create_timer(0.3).timeout
	
	player.state_machine.transition_to("Active")


func on_detail_continued():
	DungeonManager.create()
	var room: Room = DungeonManager.get_room(Vector2i.ZERO)
	var scene_path = room.scene_path
	
	if scene_path.is_empty():
		set_active(false)
		return
	
	animation_player.play_backwards("dim")
	await get_tree().create_timer(0.15).timeout
	
	var active_member_name = Constants.CharacterNames.APRIL
	ScreenTransition.transition_to_dungeon_level(
		scene_path, player_position, active_member_name, room)
