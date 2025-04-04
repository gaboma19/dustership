# https://www.dharhix.com/
extends AudioStreamPlayer

var transition_duration := 1
var transition_type := 1
var music_volume = -5
var muted_volume: float
var is_looping: bool = false
var current_song: String

var tracks: Dictionary = {
	"fanfare": "01 - Fanfare",
	"aprils_theme": "02 - April's Theme",
	"remembrancer": "03 - Remembrancer",
	"cubes_theme": "04 - Cube's Theme",
	"prickly_pear": "05 - Prickly Pear",
	"heartbeat_of_the_dustership": "06 - Heartbeat of the Dustership",
	"bao_mao": "07 - Bao Mao",
	"face_turn": "08 - Face Turn",
	"running_out_of_time": "09 - Running Out of Time",
	"glitch_monsters": "10 - Glitch Monsters",
	"cactus_knight": "11 - Cactus Knight",
	"game_over": "12 - Game Over",
	"aprils_theme_revisited": "13 - April's Theme Revisited"
}

@onready var pause_timer = $PauseTimer


func _ready():
	finished.connect(on_finished)
	pause_timer.timeout.connect(on_pause_timer_timeout)


func _init():
	volume_db = music_volume


func play_track(new_song: String, set_looping: bool = false):
	if playing && current_song == new_song:
		return
	
	current_song = new_song
	is_looping = set_looping
	fade_in(new_song)
	play()


func fade_out(duration: float = transition_duration):
	# tween music volume down to -80 (muted)
	var tween_out = create_tween()
	tween_out.tween_property(self, "volume_db", -80, duration)
	Tween.interpolate_value(music_volume, 0, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)


func fade_out_to(new_song):
	if playing:
		# tween music volume down to -80 (muted)
		var tween_out = create_tween()
		tween_out.tween_property(self, "volume_db", -80, transition_duration)
		Tween.interpolate_value(music_volume, 0, 0, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween_out.tween_callback(Callable(self, "done_fade_out").bind(new_song))
	else:
		done_fade_out(new_song)


func fade_in(new_song):
	var path = "res://music/mp3/%s.mp3"
	stream = load(str(path % tracks.get(new_song)))

	# tween music volume up to music_volume (normal/defined)
	var tween_in = create_tween()
	tween_in.tween_property(self, "volume_db", music_volume, transition_duration)
	Tween.interpolate_value(-80, 0, 0, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)


func pause_music():
	stream_paused = !stream_paused


func mute():
	muted_volume = volume_db
	volume_db = -80


func unmute():
	volume_db = muted_volume


func done_fade_out(new_song : String):
	stop()
	var path = "res://music/mp3/%s.mp3"
	stream = load(str(path % tracks.get(new_song)))
	
	# tween music volume up to music_volume (normal/defined)
	var tween_in = create_tween()
	tween_in.tween_property(self, "volume_db", music_volume, transition_duration)
	Tween.interpolate_value(-80, 0.5, 0, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	unmute()
	play()


func on_finished():
	pause_timer.start()


func on_pause_timer_timeout():
	if is_looping:
		play_track(current_song)
