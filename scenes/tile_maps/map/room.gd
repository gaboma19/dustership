extends Node
class_name Room

var neighbors: Dictionary = {
	Vector2i.UP: null,
	Vector2i.DOWN: null,
	Vector2i.LEFT: null,
	Vector2i.RIGHT: null
}

var number_of_neighbors: int = 0
