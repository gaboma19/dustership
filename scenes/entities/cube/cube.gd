extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var health_component = $HealthComponent
@onready var velocity_component = $VelocityComponent

@export var shadow: Sprite2D

var movement_vector: Vector2 = Vector2.ZERO


func _ready():
	health_component.health_changed.connect(on_health_changed)
	
	
func _process(_delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var distance = global_position.distance_to(player.global_position)
	if distance > 16:
		velocity_component.accelerate_to_player()
		velocity_component.move(self)
	else:
		velocity_component.stop()
	
	if velocity.is_zero_approx():
		set_moving(false)
	else:
		set_moving(true)
		update_blend_position(velocity.normalized())
		
	shadow.global_position = Vector2(global_position.x, global_position.y + 5)


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)


func update_blend_position(direction: Vector2):
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Move/blend_position"] = direction


func on_health_changed():
	pass
