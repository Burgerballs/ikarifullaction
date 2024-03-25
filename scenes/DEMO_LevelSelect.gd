extends Node2D
@onready var options = $"VBoxContainer".get_children()
var curSelected = 0
func _ready():
	changeSel(0)
func _unhandled_key_input(event):
	if Input.is_action_just_pressed('up'):
		changeSel(-1)
	if Input.is_action_just_pressed('down'):
		changeSel(1)
	if Input.is_action_just_pressed('enter'):
		match curSelected:
			0:
				Globals.enter_level('world_1/tutorial')
			_:
				Globals.transition_scene('res://scenes/SyobonTitle.tscn')
func changeSel(a):
	curSelected = wrap(curSelected+a, 0, options.size())
	for i in options:
		i.self_modulate = Color(0,0,0,1)
	options[curSelected].self_modulate = Color(1,1,1,1)
	if a != 0:
		Globals.play_sound('jumpBlock')
