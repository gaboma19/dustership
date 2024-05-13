extends Enemy

@onready var animation_tree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")

func _process(_delta):
	if velocity.is_zero_approx():
		set_moving(false)
	else:
		set_moving(true)


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)

func set_attacking(value):
	animation_tree.set("parameters/conditions/is_attacking", value)


func set_stunned(value: bool):
	if value:
		animation_tree.set("parameters/idle/TimeScale/scale", 0)
		animation_tree.set("parameters/walk/TimeScale/scale", 0)
		animation_tree.set("parameters/attack/TimeScale/scale", 0)
	else:
		animation_tree.set("parameters/idle/TimeScale/scale", 1)
		animation_tree.set("parameters/walk/TimeScale/scale", 1)
		animation_tree.set("parameters/attack/TimeScale/scale", 1)
