extends Node

signal item_used
signal item_added

const SIZE: int = 12

var items: Array[InventoryItem]

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	items.resize(SIZE)
	items.fill(null)


func add_item(item: InventoryItem):
	var index = items.find(null)
	if index != -1:
		items[index] = item
		item_added.emit()


func use_item(item: InventoryItem) -> bool:
	var index = items.find(item)
	if index != -1:
		items[index] = null
		if item.audio_stream != null:
			play_audio_stream(item.audio_stream)
		item_used.emit()
		return true
	else:
		return false


func use_item_by_name(item_name: String) -> bool:
	var match_name = func(item):
		if item == null: 
			return false
		if item.name == item_name:
			return true
	
	var filtered_items = items.filter(match_name)
	if filtered_items.is_empty():
		return false
	else:
		var index = items.find(filtered_items[0])
		items[index] = null
		item_used.emit()
		return true


func play_audio_stream(audio_stream: AudioStream):
	audio_stream_player.set_stream(audio_stream)
	audio_stream_player.play()


func save_data() -> Dictionary:
	var item_names: Array[String] = []
	for item in items:
		if item == null: 
			continue
		item_names.append(item.name)
	
	var data = { "items": item_names }
	return data


func load_data(data: Dictionary):
	var item_names: Array = data["items"]
	for i in item_names:
		var path = "res://resources/inventory_item/items/%s.tres"
		var inventory_item: InventoryItem = load(path % i)
		add_item(inventory_item)
