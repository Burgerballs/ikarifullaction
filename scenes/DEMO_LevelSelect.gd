extends Node2D
@onready var options = $"VBoxContainer".get_children()
@onready var nameText = $BigThing/nameLabel
@onready var scoreText = $"BigThing/scorerecent"
@onready var golhit = $Sprite2D/AnimationPlayer
@onready var yap = $Sprite2D2/AnimationPlayer
@onready var yaplabel = $Sprite2D2/Label
var curSelected = 0
var textSpeed = 20 # the amount of time in milliseconds a single glyth should take to appear
var talkin = false
var descriptions = [
	'Yknow I wonder how Jellosharp came to be, is it just one big extended family of indentical crows?',
	"Clods always get angry and make the weather go all bad, I would tell them to go to some anger management facility but clouds can't enter buildings, and I cannot leave this TV!",
	"Tibes got your buddy for trespassing so you're gonna have to break into their fortress to get her out!",
	"Yknow a long time ago these waters were completely fine to swim in and now it's all just corrosive and deadly, I wonder how that happened!\n\nP.S. There was never a Bridge-O-Matic I"
]
func _ready():
	changeSel(0)
	
var jelloTimer = 0
func _process(delta):
	if talkin:
		jelloTimer+=delta*1000
		if jelloTimer >= textSpeed:
			jelloTimer = 0
			if yaplabel.visible_characters != yaplabel.text.length():
				yaplabel.visible_characters += 1
				Globals.play_sound('yap', 1 + randf_range(-0.4, 0.4), 0,0.5)
			else:
				talkin = false
				golhit.play("idle")
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
	nameText.text = options[curSelected].get_child(0).text
	var score = HighScores.get_score(options[curSelected].get_child(0).text)
	$BigThing/scorerecent.text = str(score.score)
	yaplabel.text = descriptions[curSelected]
	yaplabel.visible_ratio = 0
	talkin = true
	golhit.play("talk")
