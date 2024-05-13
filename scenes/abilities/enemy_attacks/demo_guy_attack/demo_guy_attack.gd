extends EnemyAttack

@onready var projectile_scene = preload("res://scenes/abilities/enemy_attacks/demo_guy_attack/demo_guy_projectile.tscn")

@export var damage: int = 1


func _ready():
	cooldown_timer = $CooldownTimer


func attack():
	owner.set_moving(false)
	owner.animation_state_machine.travel("attack")
	cooldown_timer.start()
	# %AttackAudio.play_random()

func instantiate_projectile():
	var projectile = projectile_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(projectile)
	projectile.global_position = owner.global_position
