extends TileMapLayer

var obstacles: Array[Obstacle]


func _ready():
	child_entered_tree.connect(on_child_entered_tree)


func on_child_entered_tree(child: Node):
	await child.ready
	
	if child is Obstacle:
		obstacles.append(child)
