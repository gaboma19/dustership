extends Area2D

const MISSILE_EXPLOSION_SCENE = preload(
	"res://scenes/entities/telitz_denz/missile_explosion.tscn")

@export var speed = 100
@export var steer_force = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null
var entities_layer: Node2D

@onready var lifetime_timer = $LifetimeTimer


func _ready():
	body_entered.connect(on_body_entered)
	lifetime_timer.timeout.connect(on_lifetime_timeout)
	
	entities_layer = get_tree().get_first_node_in_group("entities")


func start(_transform, _target):
	global_transform = _transform
	rotation += randf_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target


func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer


func _physics_process(delta):
	if target != null:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.normalized() * speed
		rotation = velocity.angle()
	
	position += velocity * delta


func explode(body: Node2D):
	var missile_explosion = MISSILE_EXPLOSION_SCENE.instantiate()
	entities_layer.call_deferred("add_child", missile_explosion)
	missile_explosion.global_position = body.global_position
	
	queue_free()


func on_body_entered(body: Node2D):
	explode(body)


func on_lifetime_timeout():
	explode(self)
