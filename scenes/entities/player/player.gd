extends CharacterBody2D
class_name Player

@onready var ability_spawn_component = $AbilitySpawnComponent
@onready var animation_tree = $AnimationTree
@onready var damage_interval_timer = $PlayerHurtboxComponent/DamageIntervalTimer
#@onready var health_component = $HealthComponent
@onready var player_hurtbox_component: Area2D = $PlayerHurtboxComponent
@onready var speech_sound = preload("res://assets/sfx/speech_sound.wav")
@onready var state_machine = %StateMachine
@onready var velocity_component = $VelocityComponent

var movement_vector: Vector2 = Vector2.ZERO


func _ready():
	#health_component.health_changed.connect(on_health_changed)
	player_hurtbox_component.area_entered.connect(on_hurtbox_area_entered)
	#update_player_variables()
	#HealthBar.set_hearts()
	PartyManager.add_member(self)
	
	
func _process(_delta):
	pass
	#if DialogueManager.is_dialogue_active:
		#return
	#
	#movement_vector = get_movement_vector()
	#
	#if movement_vector.x != 0 || movement_vector.y != 0:
		#set_moving(true)
		#update_blend_position(movement_vector)
	#else:
		#set_moving(false)
		#
	#velocity_component.accelerate_in_direction(movement_vector)
	#velocity_component.move(self)
	
	
func speak(lines: Array[String]):
	DialogueManager.start_dialogue(global_position, lines, speech_sound)
	
	
func damage_player(damage: int):
	if not damage_interval_timer.is_stopped():
		return
	PlayerVariables.damage(damage)
	damage_interval_timer.start()
	
	
#func get_movement_vector():
	#var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")	
	#direction.y /= 2
	#direction = direction.normalized()
	#
	#return direction
	
	
func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)
	
	
func update_blend_position(direction: Vector2):
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Walk/blend_position"] = direction
	ability_spawn_component.update_blend_position(direction)
	
	
#func update_player_variables():
	#PlayerVariables.current_health = health_component.current_health
	#PlayerVariables.max_health = health_component.max_health
	
	
#func on_health_changed():
	#update_player_variables()
	#GameEvents.emit_player_damaged()
	
	
func on_hurtbox_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
		
	#if health_component == null:
		#return
		
	var hitbox_component = other_area as HitboxComponent
	damage_player(hitbox_component.damage)
