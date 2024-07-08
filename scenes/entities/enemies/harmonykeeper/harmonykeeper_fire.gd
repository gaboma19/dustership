# harmonykeeper_fire.gd
extends EnemyState

const HARMONYKEEPER_RIFLE_PROJECTILE_SCENE = preload(
	"res://scenes/entities/enemies/harmonykeeper/harmonykeeper_rifle_projectile.tscn")
const FIRE_DURATION: float = 1.0

@export var harmonykeeper_rifle_laser: RayCast2D
@export var attack_spawn: Node2D


func enter(_msg := {}) -> void:
	harmonykeeper_rifle_laser.set_casting(false)
	
	var entities_layer = get_tree().get_first_node_in_group("entities")
	var harmonykeeper_rifle_projectile = HARMONYKEEPER_RIFLE_PROJECTILE_SCENE.instantiate()
	entities_layer.add_child(harmonykeeper_rifle_projectile)
	harmonykeeper_rifle_projectile.global_position = attack_spawn.global_position
	
	var target_position = harmonykeeper_rifle_laser.cast_point
	harmonykeeper_rifle_projectile.cast(target_position)
	
	await get_tree().create_timer(FIRE_DURATION).timeout
	state_machine.transition_to("Idle")


func transition_to_idle():
	enemy.set_attacking(false)
	state_machine.transition_to("Idle")
