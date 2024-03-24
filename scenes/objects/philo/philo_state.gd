class_name EnemyState
extends State

# Typed reference to the enemy node.
var enemy: Enemy


func _ready() -> void:
	# The states are children of the `Enemy` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await owner.ready
	# The `as` keyword casts the `owner` variable to the `Enemy` type.
	# If the `owner` is not a `Enemy`, we'll get `null`.
	enemy = owner as Enemy
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Enemy.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(enemy != null)
