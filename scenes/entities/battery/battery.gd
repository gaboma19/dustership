extends StaticBody2D
class_name Battery

@export var battery_id: String
@export var chargeable_entity: Node2D

@onready var battery_charge_component: BatteryChargeComponent = \
	chargeable_entity.get_node("BatteryChargeComponent")


func _ready():
	if EntityVariables.batteries.has(battery_id):
		set_on(EntityVariables.batteries[battery_id].on)
	else:
		EntityVariables.batteries[battery_id] = { "on": false }


func set_on(value):
	if value:
		turn_on()


func turn_on():
	EntityVariables.batteries[battery_id].on = true
	$AnimationPlayer.play("on")
	$AudioStreamPlayer2D.play()
	battery_charge_component.set_charged(true)
