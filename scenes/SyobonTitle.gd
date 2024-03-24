extends Node2D

@onready var mainMenuElems = $"Container/HBoxContainer".get_children()
@onready var squareShade = $"Container/ColorRect"
var curSelected:int = 0
var speed:float = 0
var songSpeed
@onready var verLabel = $"Label"
@onready var jellosharp = $Jellosharp
func _ready():
	var randomText = [
		'Awesome!',
		'Swaggerino',
		'Yuri',
		'Burgerballs was here',
		'Ikari',
		'Lilly',
		'no syobon jr doesnt get one he suxx',
		'squiddy would kill me otherwise',
		'𝓹𝓾𝓻𝓹𝓵𝓮'
	]
	verLabel.text+= ' '+randomText.pick_random() + ' Edition'
	changeSel(0)
func _process(delta):
	squareShade.modulate.a = sin(Globals.deltaCounter*2)/6+0.3
	squareShade.global_position = mainMenuElems[curSelected].global_position
func _unhandled_key_input(event):
	if Input.is_action_just_pressed('up'):
		changeSel(-1)
	if Input.is_action_just_pressed('down'):
		changeSel(1)
	if Input.is_action_just_pressed('enter'):
		match curSelected:
			0:
				get_tree().change_scene_to_file('res://scenes/devtools/IkariTerm.tscn')
			1:
				get_tree().change_scene_to_file('res://scenes/SyobonOptions.tscn')
func changeSel(a):
	curSelected = wrap(curSelected+a, 0, mainMenuElems.size())
	jellosharp.animPlayer.play('dance')
	jellosharp.jellobox.visible = true
	jellosharp.jelloboxAnim.play('open')
	jellosharp.label.visible_ratio = 0
	jellosharp.label.text = mainMenuElems[curSelected].description
	if a != 0:
		Globals.play_sound('jumpBlock')
