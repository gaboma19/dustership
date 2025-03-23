extends Node2D

signal mouse_entered(vector: Vector2i)
signal mouse_clicked(vector: Vector2i)

@onready var center: Area2D = $Center
@onready var up: Area2D = $Up
@onready var right: Area2D = $Right
@onready var left: Area2D = $Left
@onready var down: Area2D = $Down


func _ready():
	center.mouse_entered.connect(on_mouse_entered.bind(Vector2i.ZERO))
	up.mouse_entered.connect(on_mouse_entered.bind(Vector2i.UP))
	right.mouse_entered.connect(on_mouse_entered.bind(Vector2i.RIGHT))
	left.mouse_entered.connect(on_mouse_entered.bind(Vector2i.LEFT))
	down.mouse_entered.connect(on_mouse_entered.bind(Vector2i.DOWN))
	
	center.input_event.connect(on_mouse_clicked.bind(Vector2i.ZERO))
	up.input_event.connect(on_mouse_clicked.bind(Vector2i.UP))
	right.input_event.connect(on_mouse_clicked.bind(Vector2i.RIGHT))
	left.input_event.connect(on_mouse_clicked.bind(Vector2i.LEFT))
	down.input_event.connect(on_mouse_clicked.bind(Vector2i.DOWN))


func on_mouse_entered(vector: Vector2i):
	mouse_entered.emit(vector)


func on_mouse_clicked(_viewport, event: InputEvent, _shape_idx, 
		vector: Vector2i):
	if event.is_action_pressed("attack"):
		get_tree().root.set_input_as_handled()
		mouse_clicked.emit(vector)
