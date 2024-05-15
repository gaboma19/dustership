extends StaticBody2D

@export var speed: float = 200

@onready var hitbox_component = $HitboxComponent

var target: Vector2
var direction: Vector2 = Vector2.ZERO

func _ready():
	hitbox_component.body_entered.connect(on_body_or_area_entered)
	hitbox_component.area_entered.connect(on_body_or_area_entered)
	var player = PartyManager.get_active_member()
	target = player.global_position
	direction = (target - global_position).normalized()
	var angle = direction.angle() + PI / 2
	rotation = angle


func _process(delta):
	# global_position = global_position.move_toward(target, delta * speed)
	global_position += direction * speed * delta


func on_body_or_area_entered(_body):
		queue_free()
