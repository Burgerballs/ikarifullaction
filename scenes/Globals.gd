extends CanvasLayer

@onready var text = $Label
@onready var sfx = $SFX
@onready var music = $MUSIC
var diffPhysicsProc:
	get:
		return Engine.physics_ticks_per_second / 120
var levelCached:PackedScene = preload("res://maps/world_1/tutorial.tscn")
func enter_level(level):
	levelCached = load("res://maps/"+level+".tscn").instantiate()
	get_tree().change_scene_to_file('res://scenes/SyobonGame.tscn')
var prevDelta = 0
var deltaCounter = 0
func _process(delta):
	prevDelta=deltaCounter
	deltaCounter+=delta
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if (floori(prevDelta*24) < floori(deltaCounter*24)):
		text.text = 'FPS: ' + str(snappedf(1 / delta, 0.01))
		text.text += '\nELAPSED: ' + str(snappedf(deltaCounter, 0.01))
		text.text += '\nMEM: ' + str(snappedf(OS.get_static_memory_usage()/1000000,0.1)) + 'MB'

func play_sound(sfxx, custom_pitch: float = 1.0, start_time: float = 0.0, volume: float = 1.0, bus_name:String = 'SFX'):
	var new_sound: AudioStreamPlayer = AudioStreamPlayer.new()
	new_sound.volume_db = linear_to_db(volume)
	new_sound.stream = load('res://audio/SE_'+sfxx+'.ogg')
	new_sound.pitch_scale = custom_pitch
	new_sound.finished.connect(new_sound.queue_free)
	sfx.add_child(new_sound)
	new_sound.set_bus(bus_name)
	print(new_sound.bus)
	new_sound.play(start_time)

func play_music(stream,position = 0):
	music.stream = stream
	music.play(position)
func bound(Value, Min, Max):
	var lowerBound:float = Min if (Min != null && Value < Min) else Value
	return Max if (Max != null && lowerBound > Max) else lowerBound;
func splodey(pos:Vector2):
	var magic = load("res://objects/effects/splodie.tscn").instantiate()
	play_sound('splodie', 1, 0.0, 0.7, 'reverberate')
	magic.position = pos
	get_tree().current_scene.add_child(magic)
	await get_tree().create_timer(magic.lifetime).timeout
	magic.queue_free() 
	
	
