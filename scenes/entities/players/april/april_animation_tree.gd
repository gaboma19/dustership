extends AnimationTree

var number_attacks: int = 0

@onready var attack_combo_timer = %AttackComboTimer


func _ready():
	attack_combo_timer.timeout.connect(on_combo_timeout)


func update_blend_position(direction: Vector2):
	set("parameters/Idle/blend_position", direction)
	set("parameters/Move/blend_position", direction)
	set("parameters/Attack 1/blend_position", direction)
	set("parameters/Attack 2/blend_position", direction)
	set("parameters/Attack 3/blend_position", direction)


func reset_number_attacks():
	number_attacks = 0


func on_combo_timeout():
	reset_number_attacks()
