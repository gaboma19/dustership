extends RigidBody2D

@onready var floor_static_body = $FloorStaticBody


func _ready():
	floor_static_body.global_position.y = global_position.y


func _physics_process(_delta):
	floor_static_body.global_position.x = global_position.x
