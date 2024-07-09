extends CharacterBody2D
class_name Player

@export var character_name: Constants.CharacterNames

var blend_position: Vector2 = Vector2.DOWN
var hit_flash_tween: Tween

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var damage_interval_timer = $PlayerHurtboxComponent/DamageIntervalTimer
@onready var player_hurtbox_component: Area2D = $PlayerHurtboxComponent
@onready var speech_sound = preload("res://assets/sfx/speech_sound.wav")
@onready var state_machine = %StateMachine
@onready var velocity_component = $VelocityComponent
@onready var sprite = $Sprite2D


func _ready():
	player_hurtbox_component.area_entered.connect(on_hurtbox_area_entered)
	player_hurtbox_component.hitbox_detected.connect(on_hitbox_detected)
	PartyManager.add_member(self)
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 0)
	
	if character_name == Constants.CharacterNames.CUBE:
		instantiate_shadow()


func speak(lines: Array[String]):
	DialogueManager.start_dialogue(global_position, lines, speech_sound)


func damage_player(damage: int):
	if not damage_interval_timer.is_stopped():
		return
	hit_flash()
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
	
	blend_position = direction


func hit_flash():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	($Sprite2D.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property($Sprite2D.material, "shader_parameter/lerp_percent", 0.0, 0.25) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)


func can_attack():
	match character_name:
		Constants.CharacterNames.APRIL:
			return PlayerVariables.has_sword
		Constants.CharacterNames.CUBE:
			return PlayerVariables.has_gun
		Constants.CharacterNames.TELITZ:
			return true


func instantiate_shadow():
	const SHADOW_SPRITE_SCENE = preload("res://scenes/entities/cube/shadow_sprite.tscn")
	var shadow_sprite = SHADOW_SPRITE_SCENE.instantiate()
	shadow_sprite.flying_entity = self
	shadow_sprite.y_offset = 5
	get_parent().add_child.call_deferred(shadow_sprite)
	shadow_sprite.global_position = Vector2(global_position.x, global_position.y + 5)


func set_flying(value: bool):
	if value:
		set_collision_mask(0b10000001)
	else:
		set_collision_mask(0b1010100001)


func on_hurtbox_area_entered(hitbox_component: Area2D):
	if not hitbox_component is HitboxComponent:
		return
	
	if DialogueManager.is_dialogue_active:
		return

	damage_player(hitbox_component.damage)


func on_hitbox_detected(damage: int):
	damage_player(damage)
