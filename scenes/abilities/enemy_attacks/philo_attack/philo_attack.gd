extends EnemyAttack

@export var hitbox_component: HitboxComponent
@export var damage: int = 1


func _ready():
	cooldown_timer = $CooldownTimer
	hitbox_component.damage = damage


func attack():
	owner.animation_state_machine.travel("attack")
	cooldown_timer.start()
	%AttackAudio.play_random()


func dash():
	var player = PartyManager.get_active_member()
	var direction = owner.global_position.direction_to(player.global_position)
	var tween = create_tween()
	tween.tween_property(owner, "position", direction * 16, 0.1) \
		.set_ease(Tween.EASE_IN).as_relative()
