extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var stun_component: StunComponent

var floating_text_scene = preload("res://scenes/ui/floating_text/floating_text.tscn")


func _ready():
	area_entered.connect(on_area_entered)


func hit(damage: int):
	if health_component == null:
		return

	health_component.damage(damage)
		
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground").add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	
	var format_string = "%0.1f"
	if round(damage) == damage:
		format_string = "%0.0f"
	floating_text.start(format_string % damage)


func stun(stun_duration: float):
	if stun_component == null:
		return
		
	stun_component.stun_duration = stun_duration
	
	(owner as Enemy).state_machine.transition_to("Stun")


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent or StunboxComponent:
		return
		
	if other_area is HitboxComponent:
		var hitbox_component = other_area as HitboxComponent
		hit(hitbox_component.damage)
	elif other_area is StunboxComponent:
		var stunbox_component = other_area as StunboxComponent
		stun(stunbox_component.stun_duration)
