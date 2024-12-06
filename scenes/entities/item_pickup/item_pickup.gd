extends Node2D

@export var item: InventoryItem

@onready var collision_shape_2d = $CollectionArea/CollisionShape2D
@onready var sprite = $Sprite2D


func _ready():
	$CollectionArea.area_entered.connect(on_collection_area_entered)
	sprite.texture = item.texture
	tween_bounce()


func tween_bounce():
	var direction: Vector2
	if randf() > 0.5: 
		direction = Vector2.RIGHT 
	else: 
		direction = Vector2.LEFT

	var tween = create_tween()
	tween.tween_property(self, "position", direction * 48, 1).as_relative()


func tween_collect(percent: float, start_position: Vector2):
	var player = PartyManager.get_active_member()
	if player == null:
		return
		
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(
		rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect():
	Inventory.add_item(item)


func disable_collision():
	collision_shape_2d.disabled = true


func on_collection_area_entered(_area: Area2D):
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)
