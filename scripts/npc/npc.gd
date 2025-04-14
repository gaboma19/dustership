extends CharacterBody2D
class_name Npc

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var speech_sound = preload("res://assets/sfx/speech_sound.wav")
@onready var interaction_area: Area2D = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree


func speak(lines: Array[String]):
	var canvas_pos = get_global_transform_with_canvas().origin
	print(canvas_pos)
	DialogueManager.start_dialogue(canvas_pos, lines, speech_sound)
