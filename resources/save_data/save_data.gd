extends Resource
class_name SaveData


var items: Array[InventoryItem]

var active_layer: TileMap
var player_map_position: Vector2i = Vector2i.ZERO
var dungeons: Dictionary = {}

var member_scenes: Array[PackedScene] = []

var current_health: int
var max_health: int = 3
var steel: int = 0
var pause_menu_screen: int = 0
var has_sword: bool = false
var has_gun: bool = true
