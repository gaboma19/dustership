extends Node

# %appdata%\Dustership\save_game.save
const SAVE_PATH = "user://save_game.save"


func save_game():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if not node.has_method("save_data"):
			push_warning("%s is missing save_data method; skipped." % node.name)
			continue
		
		var node_data = node.call("save_data")
		node_data = { node.name: node_data }
		
		var json_string = JSON.stringify(node_data)
		
		print(json_string)
		
		save_file.store_line(json_string)


func has_save_data() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func load_game():
	if not has_save_data():
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			push_warning("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var data: Dictionary = json.get_data()
		var node_name: String = data.keys().front()
		var node = get_tree().root.get_node(node_name)
		var node_data = data[node_name]
		
		if node == null:
			push_warning("%s not found; skipped" % node_name)
			continue
		
		if not node.has_method("load_data"):
			push_warning("%s is missing load_data method; skipped." % node.name)
			continue
		
		node.load_data(node_data)
