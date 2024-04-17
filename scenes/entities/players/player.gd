extends CharacterBody2D
class_name Player

@export var character_name: Constants.CharacterNames

var movement_vector: Vector2 = Vector2.ZERO

@onready var animation_tree = $AnimationTree
@onready var damage_interval_timer = $PlayerHurtboxComponent/DamageIntervalTimer
@onready var player_hurtbox_component: Area2D = $PlayerHurtboxComponent
@onready var speech_sound = preload("res://assets/sfx/speech_sound.wav")
@onready var state_machine = %StateMachine
@onready var velocity_component = $VelocityComponent


func _ready():
	player_hurtbox_component.area_entered.connect(on_hurtbox_area_entered)
	PartyManager.add_member(self)


func _exit_tree():
	PartyManager.remove_member(self)


func speak(lines: Array[String]):
	DialogueManager.start_dialogue(global_position, lines, speech_sound)


func damage_player(damage: int):
	if not damage_interval_timer.is_stopped():
		return
	PlayerVariables.damage(damage)
	damage_interval_timer.start()


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)


func set_attacking(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", not value)
	animation_tree.set("parameters/conditions/is_attacking", value)


func update_blend_position(direction: Vector2):
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Move/blend_position"] = direction
	animation_tree["parameters/Attack/blend_position"] = direction


func on_hurtbox_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	var hitbox_component = other_area as HitboxComponent
	damage_player(hitbox_component.damage)
