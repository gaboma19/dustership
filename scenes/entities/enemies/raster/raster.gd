extends Enemy


func update_animation_tree():
	if velocity.is_zero_approx():
		set_moving(false)
	else:
		set_moving(true)
		update_blend_position(velocity.x)


func update_blend_position(direction: float):
	animation_tree["parameters/walk/BlendSpace1D/blend_position"] = direction
	animation_tree["parameters/idle/BlendSpace1D/blend_position"] = direction


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)


func set_stunned(value: bool):
	if value:
		animation_tree.set("parameters/idle/TimeScale/scale", 0)
		animation_tree.set("parameters/walk/TimeScale/scale", 0)
		animation_tree.set("parameters/attack/TimeScale/scale", 0)
	else:
		animation_tree.set("parameters/idle/TimeScale/scale", 1)
		animation_tree.set("parameters/walk/TimeScale/scale", 1)
		animation_tree.set("parameters/attack/TimeScale/scale", 1)
