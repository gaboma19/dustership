extends Node
class_name MapGenerator

const GENERATION_CHANCE: float = 0.2

@export var room_scene: PackedScene

var min_number_rooms = 6
var max_number_rooms = 10
var map: Dictionary = {}
var size: int = 0


func generate(map_seed):
	seed(map_seed)
	
	size = randi_range(min_number_rooms, max_number_rooms)
	
	add_entrance()
	size -= 1
	
	while size > 0:
		for coord in map:
			if size > 0:
				if randf() < GENERATION_CHANCE:
					var direction = randi_range(1, 4)
					if direction == 1:
						add_neighbor(coord, Vector2i.RIGHT)
					elif direction == 2:
						add_neighbor(coord, Vector2i.LEFT)
					elif direction == 3:
						add_neighbor(coord, Vector2i.UP)
					elif direction == 4:
						add_neighbor(coord, Vector2i.DOWN)
	
	while not is_interesting():
		clear()
		map = generate(map_seed * randf_range(-1, 1) + randf_range(-1, 1))
	
	add_exit()
	
	return map


func clear():
	for pos in map.keys():
		map.get(pos).queue_free()
	
	map.clear()


func add_neighbor(position: Vector2i, direction: Vector2i):
	var new_room_position: Vector2i = position + direction
	
	if not map.has(new_room_position):
		map[new_room_position] = room_scene.instantiate()
		size -= 1
	
	if map.get(position).neighbors.get(direction) == null:
		connect_rooms(map.get(position), map.get(new_room_position), direction)


func connect_rooms(room_1, room_2, direction: Vector2i):
	room_1.neighbors[direction] = room_2
	room_2.neighbors[-direction] = room_1
	room_1.number_of_neighbors += 1
	room_2.number_of_neighbors += 1


func is_interesting():
	var number_rooms_with_three_neighbors = 0
	for i in map.keys():
		if map.get(i).number_of_neighbors >= 3:
			number_rooms_with_three_neighbors += 1
	
	return number_rooms_with_three_neighbors >= 2


func add_entrance():
	var entrance_room = room_scene.instantiate()
	entrance_room.type = Room.Type.ENTRANCE
	map[Vector2i(0, 0)] = entrance_room


func add_exit():
	var exit_room = get_longest_path_room()
	exit_room.type = Room.Type.EXIT


func get_longest_path_room(start: Vector2i = Vector2i.ZERO) -> Room:
	var queue = [start]
	var visited = { start: 0 }
	var longest_room = map[start]
	var longest_length = 0
	
	while not queue.is_empty():
		var current = queue.pop_front()
		var current_length = visited[current]
		var current_room: Room = map[current]
	
		if (
			current_length > longest_length
			and current_room.number_of_neighbors == 1
		):
			longest_length = current_length
			longest_room = current_room
	
		for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var neighbor_coord = current + direction
			if neighbor_coord in map and neighbor_coord not in visited:
				queue.append(neighbor_coord)
				visited[neighbor_coord] = current_length + 1
	
	return longest_room
