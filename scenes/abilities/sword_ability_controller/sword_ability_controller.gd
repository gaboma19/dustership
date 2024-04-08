extends Node

@export var sword_ability: PackedScene
@export var damage: int = 5
@onready var timer = $Timer

var attack_animation = preload("res://scenes/abilities/sword_ability/attack.res")
var attack_time: float = attack_animation.length
var player: Player
var sword_instance: SwordAbility


func _ready():
	player = get_tree().get_first_node_in_group("player") as Player
	timer.wait_time = attack_time


func _process(_delta):
	if player != null:
		update_sword_position(player.ability_spawn_component.global_position)


func _input(event):
	if event.is_action_pressed("attack") && %StateMachine.state.name == "Active":
		attack()
		get_tree().root.set_input_as_handled()


func attack():
	if !timer.is_stopped():
		return
	timer.start()
	
	sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_node = get_tree().get_first_node_in_group("foreground")
	
	foreground_node.add_child(sword_instance)
	sword_instance.global_position = player.ability_spawn_component.global_position
	sword_instance.rotation = player.ability_spawn_component.rotation
	sword_instance.hitbox_component.damage = damage


func update_sword_position(position: Vector2):
	if sword_instance == null:
		return
		
	sword_instance.global_position = position
