extends AnimationTree


func update_blend_position(direction: Vector2):
	set("parameters/Idle/blend_position", direction)
	set("parameters/Move/blend_position", direction)
	set("parameters/Attack/blend_position", direction)
