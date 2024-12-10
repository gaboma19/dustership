extends AnimationTree

var number_attacks: int = 0


func is_attacking() -> bool:
	return get("parameters/conditions/is_attacking")
