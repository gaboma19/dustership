extends Node2D

signal mouse_entered(vector: Vector2i)
signal mouse_clicked(vector: Vector2i)

@onready var center: Area2D = $Center
@onready var up: Area2D = $Up
@onready var right: Area2D = $Right
@onready var left: Area2D = $Left
@onready var down: Area2D = $Down


func _ready():
	center.mouse_entered.connect(on_center_detected)
	up.mouse_entered.connect(on_up_detected)
	right.mouse_entered.connect(on_right_detected)
	left.mouse_entered.connect(on_left_detected)
	down.mouse_entered.connect(on_down_detected)
	
	center.input_event.connect(on_center_event)


func on_center_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("attack"):
		mouse_clicked.emit(Vector2i.ZERO)


func on_center_detected():
	mouse_entered.emit(Vector2i.ZERO)


func on_up_detected():
	mouse_entered.emit(Vector2i.UP)


func on_right_detected():
	mouse_entered.emit(Vector2i.RIGHT)


func on_left_detected():
	mouse_entered.emit(Vector2i.LEFT)


func on_down_detected():
	mouse_entered.emit(Vector2i.DOWN)
