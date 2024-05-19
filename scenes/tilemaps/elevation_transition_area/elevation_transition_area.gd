extends Area2D

var enable_tile_set: TileSet = null
var disable_tile_set: TileSet = null

@export var enable_tile_map: TileMap
@export var disable_tile_map: TileMap


func _ready():
	body_entered.connect(on_body_entered)
	
	if enable_tile_map != null:
		enable_tile_set = enable_tile_map.tile_set
	if disable_tile_map != null:
		disable_tile_set = disable_tile_map.tile_set


func on_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if player != body:
		return
	
	if enable_tile_set != null:
		enable_tile_set.set_physics_layer_collision_layer(1, 0b100000)
	if disable_tile_set != null:
		disable_tile_set.set_physics_layer_collision_layer(1, 0)
