extends Node

const CACTUS_KNIGHT_SCENE = preload(
	"res://scenes/entities/enemies/cactus_knight/cactus_knight.tscn")

@export var boss_moving_platform: Node2D

@onready var boss_platform = $BossPlatform
@onready var trap_area = $TrapArea


func _ready():
	trap_area.body_entered.connect(on_body_entered_trap)


func on_body_entered_trap(player: Player):
	trap_area.set_deferred("monitoring", false)
	
	player.state_machine.transition_to("Hold")
	PartyManager.disable_switch_character(true)
	
	boss_moving_platform.animation_player.play_backwards("move")
	
	var cactus_knight = CACTUS_KNIGHT_SCENE.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(cactus_knight)
	cactus_knight.global_position = boss_platform.global_position
	
	var health_component = cactus_knight.get_node("HealthComponent")
	health_component.died.connect(on_cactus_knight_died)
	
	var state_machine = cactus_knight.get_node("StateMachine")
	state_machine.transition_to("Spawn")
	await get_tree().create_timer(4.0).timeout
	state_machine.transition_to("Shoot")
	
	player.state_machine.transition_to("Active")
	PartyManager.disable_switch_character(false)


func on_cactus_knight_died():
	boss_moving_platform.animation_player.play_backwards("move")
