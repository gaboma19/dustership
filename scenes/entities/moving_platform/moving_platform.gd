extends Node2D

var is_at_destination: bool
var player: Player

@onready var collision_polygon_2d = %CollisionPolygon2D
@onready var animatable_body_2d = $AnimatableBody2D
@onready var activation_area = %ActivationArea
@onready var offboarding_area = %OffboardingArea


func _ready():
	activation_area.body_entered.connect(on_activation_area_body_entered)
	offboarding_area.body_entered.connect(on_offboarding_area_body_entered)


func end_move():
	collision_polygon_2d.set_deferred("disabled", true)
	set_party_flying(false)


func set_party_flying(value):
	for member in PartyManager.members:
		(member as Player).set_flying(value)


func on_activation_area_body_entered(body: Node2D):
	collision_polygon_2d.set_deferred("disabled", false)
	activation_area.set_deferred("monitoring", false)
	
	$AnimatableBody2D/Sprite2D/AnimationPlayer.play("default")
	await get_tree().create_timer(0.4).timeout
	set_party_flying(true)
	
	if is_at_destination:
		$AnimationPlayer.play_backwards("move")
		is_at_destination = false
	else:
		$AnimationPlayer.play("move")
		is_at_destination = true
	$AnimationPlayer.queue("call_end_move")
	
	player = body
	player.reparent(animatable_body_2d)
	# add player back to party because reparent() calls player._exit_tree()
	PartyManager.add_member(player)


func on_offboarding_area_body_entered(_body: Node2D):
	activation_area.set_deferred("monitoring", true)
