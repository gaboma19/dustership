extends EnemyAttack

@onready var projectile_array_scene = preload("res://scenes/abilities/enemy_attacks/raster_attack/raster_projectile_array.tscn")

@export var damage: int = 1


func _ready():
	cooldown_timer = $CooldownTimer


func attack():
	owner.set_moving(false)
	owner.animation_state_machine.travel("attack")
	cooldown_timer.start()
	%AttackAudio.play_random()


func instantiate_projectile_array():
	var projectile_array = projectile_array_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(projectile_array)
	projectile_array.global_position = owner.global_position
