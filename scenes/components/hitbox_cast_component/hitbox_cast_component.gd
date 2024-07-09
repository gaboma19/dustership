extends ShapeCast2D
class_name HitboxCastComponent

@export var damage: int = 0


func _process(_delta):
	if is_colliding():
		var player_hurtbox: PlayerHurtboxComponent = collision_result[0].collider
		if player_hurtbox.is_monitorable():
			player_hurtbox.emit_hitbox_detected(damage)
