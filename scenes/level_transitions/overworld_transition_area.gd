extends Area2D


func _ready():
	body_entered.connect(on_body_entered)


func transition_to_overworld():
	MusicManager.fade_out(10)
	set_deferred("monitoring", false)
	
	ScreenTransition.transition_to_overworld()


func on_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	transition_to_overworld()
