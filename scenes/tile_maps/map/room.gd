extends Node
class_name Room

enum Type { DEFAULT, ENTRANCE, EXIT }

var neighbors: Dictionary = {
	Vector2i.UP: null,
	Vector2i.DOWN: null,
	Vector2i.LEFT: null,
	Vector2i.RIGHT: null
}

var number_of_neighbors: int = 0
var scene_path: String = ""
var map_position: Vector2i = Vector2i.ZERO
var type: Type = Type.DEFAULT
var visited: bool = false
