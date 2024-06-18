extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var stun_component: StunComponent
@export var knockback_component: KnockbackComponent


func _ready():
	area_entered.connect(on_area_entered)


func hit(damage: int):
	if health_component == null:
		return

	health_component.damage(damage)


func stun(stun_duration: float):
	if stun_component == null:
		return
		
	stun_component.stun_duration = stun_duration
	
	var current_state = (owner as Enemy).state_machine.state.name
	var msg = {
		"previous_state": current_state
	}
	
	owner.state_machine.transition_to("Stun", msg)


func knockback(direction: Vector2):
	if knockback_component == null:
		return
	
	knockback_component.direction = direction
	
	var current_state = (owner as Enemy).state_machine.state.name
	var msg = {
		"previous_state": current_state
	}
	
	owner.state_machine.transition_to("Knockback", msg)


func on_area_entered(other_area: Area2D):
	if other_area is HitboxComponent:
		var hitbox_component = other_area as HitboxComponent
		hit(hitbox_component.damage)
	elif other_area is StunboxComponent:
		var stunbox_component = other_area as StunboxComponent
		stun(stunbox_component.stun_duration)
	elif other_area is KnockboxComponent:
		var knockbox_component = other_area as KnockboxComponent
		knockback(knockbox_component.knockback_direction)
	else:
		return
