extends GutTest

var _sender = InputSender.new(Input)
var party_manager = load("res://scenes/autoload/party_manager.gd")



func before_all():
	PartyManager.free()


func after_each():
	_sender.release_all()
	_sender.clear()


func test_switch_character_input():
	var doubled_party_manager = double(party_manager).new()
	stub(doubled_party_manager, "switch_character").to_do_nothing()
	
	_sender.action_down("switch_character").wait(0.1)
	await(_sender.idle)
	
	assert_call_count(doubled_party_manager, "switch_character", 1)
