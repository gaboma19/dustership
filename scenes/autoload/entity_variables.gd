extends Node

## EntityVariables are not saved by the SaveManager

# "chest_id": {
#	"opened": false,
#	"spawned": false,
#	"sprite": sprite_index
# }
var chests: Dictionary = {}

# "conversation_id": {
#	"interacted": false
# }
var conversations: Dictionary = {}

# "door_id": {
#	"opened": false
# }
var doors: Dictionary = {}

#"battery_id": {
#	"on": false
#}
var batteries: Dictionary = {}

var last_dustership_location: String = "Apartment"
