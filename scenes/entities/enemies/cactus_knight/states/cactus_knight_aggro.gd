# cactus_knight_aggro.gd
extends EnemyState

var is_three_quarters_health: bool = false
var is_half_health: bool = false
var is_quarter_health: bool = false

@onready var attack_cooldown_timer = %AttackCooldownTimer
@onready var health_component = %HealthComponent
@onready var attack_range_area = %AttackRangeArea
@onready var events = get_tree().get_first_node_in_group("events")


func enter(_msg := {}) -> void:
	attack_range_area.body_entered.connect(on_attack_range_body_entered)
	health_component.health_changed.connect(on_health_changed)


func update(_delta: float) -> void:
	enemy.velocity_component.accelerate_to_player()
	enemy.velocity_component.move(enemy)
	
	var player = PartyManager.get_active_member()
	if player != null:
		if attack_range_area.overlaps_body(player):
			on_attack_range_body_entered(player)


func exit():
	attack_range_area.body_entered.disconnect(on_attack_range_body_entered)
	health_component.health_changed.disconnect(on_health_changed)


func transition_to_shoot():
	state_machine.transition_to("Shoot")


func on_health_changed():
	var quarter_health = floor(health_component.max_health / 4)
	if health_component.current_health < quarter_health * 3:
		if not is_three_quarters_health:
			is_three_quarters_health = true
			events.spawn_philo()
			transition_to_shoot()
	elif health_component.current_health < quarter_health * 2:
		if not is_half_health:
			is_half_health = true
			events.spawn_philo()
			transition_to_shoot()
	elif health_component.current_health < quarter_health:
		if not is_quarter_health:
			is_quarter_health = true
			events.spawn_philo()
			transition_to_shoot()


func on_attack_range_body_entered(_body: Node2D):
	if attack_cooldown_timer.is_stopped():
		attack_cooldown_timer.start()
		state_machine.transition_to("Attack")
