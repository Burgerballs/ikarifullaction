extends CanvasLayer

@onready var text = $Label
@onready var sfx = $SFX
@onready var music = $MUSIC
var diffPhysicsProc:
	get:
		return Engine.physics_ticks_per_second / 120 
var currentLevel = 'testicals/jumptest'
func enter_level(level):
	currentLevel = level
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

func play_sound(sfxx):
	sfx.set_stream(load('res://audio/SE_'+sfxx+'.ogg'))
	sfx.play()
func play_music(stream,position = 0):
	music.stream = stream
	music.play(position)
func bound(Value, Min, Max):
	var lowerBound:float = Min if (Min != null && Value < Min) else Value
	return Max if (Max != null && lowerBound > Max) else lowerBound;
