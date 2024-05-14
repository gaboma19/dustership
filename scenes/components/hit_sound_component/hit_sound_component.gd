extends Node

@export var audio_stream: AudioStream
@export var health_component: HealthComponent

@onready var audio_stream_player = $RandomAudioStreamPlayer2D


func _ready():
	audio_stream_player.streams.append(audio_stream)
	health_component.health_changed.connect(on_health_changed)


func on_health_changed():
	audio_stream_player.play_random()
