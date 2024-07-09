extends Area2D
class_name PlayerHurtboxComponent

signal hitbox_detected(damage: int)


func emit_hitbox_detected(damage: int):
	hitbox_detected.emit(damage)
