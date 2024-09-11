extends Node

@export var room_scene: PackedScene

var min_number_rooms = 6
var max_number_rooms = 10
var generation_chance: float = 0.2
var map: Dictionary = {}
var size: int = 0


func generate(map_seed):
	seed(map_seed)
	
	size = randi_range(6, 10)
	
	map[Vector2(0, 0)] = room_scene.instantiate()
	size -= 1
	
	while size > 0:
		for i in map.keys():
			if randf() < generation_chance:
				var direction = randi_range(1, 4)
				if direction == 1:
					add_neighbor(i, Vector2.RIGHT)
				elif direction == 2:
					add_neighbor(i, Vector2.LEFT)
				elif direction == 3:
					add_neighbor(i, Vector2.UP)
				elif direction == 4:
					add_neighbor(i, Vector2.DOWN)
	
	while not is_interesting(map):
		for i in map.keys():
			map.get(i).queue_free()
		map = generate(map_seed * randf_range(-1, 1) + randf_range(-1, 1))
	return map


func add_neighbor(position: Vector2, direction: Vector2):
	var new_room_position = position + direction
	
	if not map.has(new_room_position):
		map[new_room_position] = room_scene.instantiate()
		size -= 1
	if map.get(position).neighbors.get(direction) == null:
		connect_rooms(map.get(position), map.get(new_room_position), direction)


func connect_rooms(room_1, room_2, direction: Vector2):
	room_1.neighbors[direction] = room_2
	room_2.neighbors[-direction] = room_1
	room_1.number_of_neighbors += 1
	room_2.number_of_neighbors += 1


func is_interesting(dungeon):
	var number_rooms_with_three_neighbors = 0
	for i in dungeon.keys():
		if dungeon.get(i).number_of_connections >= 3:
			number_rooms_with_three_neighbors += 1
	
	return number_rooms_with_three_neighbors >= 2
