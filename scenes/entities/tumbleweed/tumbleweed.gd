extends Node2D

@onready var rigid_body_2d = $RigidBody2D
@onready var floor_static_body = $FloorStaticBody


func _ready():
	rigid_body_2d.apply_impulse(Vector2(100, -250))


func _physics_process(_delta):
	floor_static_body.global_position.x = rigid_body_2d.global_position.x
