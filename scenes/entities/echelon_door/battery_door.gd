extends Node2D

@export var door_id: String

var floating_text_scene = preload("res://scenes/ui/floating_text/floating_text.tscn")

@onready var interaction_area = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var battery_charge_component = $BatteryChargeComponent


func _ready():
	battery_charge_component.charged.connect(on_charged)
	interaction_area.interact = Callable(self, "on_interact")
	
	if EntityVariables.doors.has(door_id):
		set_opened(EntityVariables.doors[door_id].opened)
	else:
		EntityVariables.doors[door_id] = { "opened": false }


func set_opened(value: bool):
	if value:
		animation_player.play("set_open")
		interaction_area.monitoring = false


func open():
	animation_player.play("open")
	interaction_area.monitoring = false
	$AudioStreamPlayer2D.play()


func on_interact():
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start("The door is locked.")


func on_charged():
	open()
