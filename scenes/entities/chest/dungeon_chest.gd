extends Chest
class_name DungeonChest

const ITEM_PICKUP_SCENE: PackedScene = preload(
	"res://scenes/entities/item_pickup/item_pickup.tscn")
const STEEL_SCENE: PackedScene = preload(
	"res://scenes/entities/steel/steel.tscn")

@export var number_steel: int = 10

@onready var animations: PackedStringArray = \
	animated_sprite_2d.sprite_frames.get_animation_names()
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	hide()
	
	shadow_sprite.animation = animated_sprite_2d.animation
	interaction_area.interact = Callable(self, "on_interact")


func build(id: String):
	chest_id = id
	if EntityVariables.chests.has(chest_id):
		set_state(EntityVariables.chests[chest_id])
	else:
		create_state()


func create_state():
	var sprite_index = randi_range(0, Chest.Sprites.size() - 1)
	animated_sprite_2d.animation = animations[sprite_index]
	
	EntityVariables.chests[chest_id] = { 
		"opened": false,
		"spawned": false,
		"sprite": sprite_index
	}


func set_state(chest_data: Dictionary):
	animated_sprite_2d.animation = animations[chest_data.sprite]
	
	if chest_data.spawned:
		show()
		interaction_area.monitoring = true
		collision_shape_2d.disabled = false
	
	if chest_data.opened:
		animated_sprite_2d.set_frame(1)
		interaction_area.monitoring = false


func spawn():
	EntityVariables.chests[chest_id].spawned = true
	interaction_area.monitoring = true
	super()


func spawn_item_pickup():
	if inventory_item == null:
		return
	
	var item_pickup = ITEM_PICKUP_SCENE.instantiate()
	item_pickup.item = inventory_item
	entities_layer.add_child(item_pickup)
	item_pickup.global_position = self.global_position


func spawn_steel():
	var mod = randi_range(-4, 4)
	number_steel += mod
	
	var angle = (1.0 / number_steel) * TAU
	
	for n in number_steel:
		var steel = STEEL_SCENE.instantiate()
		steel.angle = n * angle
		entities_layer.add_child(steel)
		steel.global_position = self.global_position


func on_interact():
	EntityVariables.chests[chest_id].opened = true
	
	$AudioStreamPlayer2D.play()
	animated_sprite_2d.play()
	interaction_area.monitoring = false
	
	spawn_item_pickup()
	spawn_steel()
