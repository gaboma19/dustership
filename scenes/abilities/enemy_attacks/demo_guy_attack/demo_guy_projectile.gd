extends StaticBody2D

@export var speed: float = 150

@onready var hitbox_component = $HitboxComponent

var direction: Vector2 = Vector2.ZERO

func _ready():
	hitbox_component.body_entered.connect(on_body_or_area_entered)
	hitbox_component.area_entered.connect(on_body_or_area_entered)
	var player = PartyManager.get_active_member()
	direction = global_position.direction_to(player.global_position)
	# Calculating the angle of the projectile sprite, not the projectile itself
	var angle = direction.angle() + PI / 2
	rotation = angle


func _physics_process(delta):
	global_position += direction * speed * delta


func on_body_or_area_entered(_body):
		queue_free()
