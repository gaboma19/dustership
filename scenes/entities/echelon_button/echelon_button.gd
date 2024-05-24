extends StaticBody2D

@export var battery_id: String
@export var chargeable_entity: Node2D

@onready var interaction_area = $InteractionArea
@onready var animation_player = $AnimationPlayer

var battery_charge_component: BatteryChargeComponent


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if chargeable_entity != null:
		battery_charge_component = chargeable_entity.get_node(
			"BatteryChargeComponent")
	
	if EntityVariables.batteries.has(battery_id):
		set_on(EntityVariables.batteries[battery_id].on)
	else:
		EntityVariables.batteries[battery_id] = { "on": false }


func set_on(value: bool):
	if value:
		animation_player.play("default")
		battery_charge_component.set_charged(true)


func on_interact():
	set_on(true)
	$AudioStreamPlayer2D.play()
