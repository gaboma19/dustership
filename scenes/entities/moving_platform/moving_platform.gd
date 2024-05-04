extends Node2D

@export var animation_player: AnimationPlayer

var is_at_destination: bool
var player: Player

@onready var collision_polygon_2d = %CollisionPolygon2D
@onready var animatable_body_2d = $AnimatableBody2D
@onready var activation_area = %ActivationArea
@onready var offboarding_area = %OffboardingArea
@onready var battery_charge_component = $BatteryChargeComponent
@onready var charge_sprite = %ChargeSprite


func _ready():
	activation_area.body_entered.connect(on_activation_area_body_entered)
	offboarding_area.body_entered.connect(on_offboarding_area_body_entered)
	battery_charge_component.charged.connect(on_charged)


func end_move():
	collision_polygon_2d.set_deferred("disabled", true)
	set_party_flying(false)
	
	var entities_layer = get_tree().get_first_node_in_group("entities")
	for member in PartyManager.members:
		member.reparent(entities_layer)


func set_party_flying(value):
	for member in PartyManager.members:
		(member as Player).set_flying(value)


func on_activation_area_body_entered(_body: Node2D):
	if battery_charge_component.is_charged == false:
		return
	
	collision_polygon_2d.set_deferred("disabled", false)
	activation_area.set_deferred("monitoring", false)
	
	$AnimatableBody2D/Sprite2D/AnimationPlayer.play("default")
	
	await get_tree().create_timer(0.4).timeout
	set_party_flying(true)
	
	if is_at_destination:
		animation_player.play_backwards("move")
		is_at_destination = false
	else:
		animation_player.play("move")
		is_at_destination = true
	animation_player.queue("call_end_move")
	
	for member in PartyManager.members:
		member.reparent(animatable_body_2d)
		
	PartyManager.rubberband_party()


func on_offboarding_area_body_entered(_body: Node2D):
	activation_area.set_deferred("monitoring", true)


func on_charged():
	charge_sprite.show()
