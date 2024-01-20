extends CanvasLayer
@export var options:Array[OptionBase]
@onready var templateLabel = $Label
@onready var highlight = $NinePatchRect/highlight
var labels:
	get:
		return $NinePatchRect/VBoxContainer.get_children()
var cur_select = 0
var curSelectType = OptionTypes.OptionType.BOOLEAN
var doThing = false
@onready var value = $NinePatchRect2/Value
@onready var desc = $NinePatchRect2/Description
# Called when the node enters the scene tree for the first time.
func _ready():
	make_options()
	changeSel(0)
	doThing = true
	Globals.music.set_stream(load("res://audio/bgm/BGM_settings.ogg"))
	Globals.music.play()

func make_options():
	for i in options:
		var newLabel = templateLabel.duplicate()
		newLabel.text = i.option_screen_name
		$NinePatchRect/VBoxContainer.add_child(newLabel)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	highlight.modulate.a = sin(Globals.deltaCounter*2)/6+0.3
	if doThing:
		highlight.position = labels[cur_select].position + Vector2(30, 30)
func _unhandled_key_input(event):
	if Input.is_action_just_pressed('up'):
		changeSel(-1)
	if Input.is_action_just_pressed('down'):
		changeSel(1)
	if Input.is_action_just_pressed('left'):
		changeOpt(-1)
	if Input.is_action_just_pressed('right'):
		changeOpt(1)
	if Input.is_action_just_pressed('dash'):
		get_tree().change_scene_to_file('res://scenes/SyobonTitle.tscn')
func changeSel(a):
	cur_select = wrap(cur_select+a, 0, options.size())
	value.text = options[cur_select].display_opt()
	desc.text = options[cur_select].option_description
	if a != 0:
		Globals.play_sound('jumpBlock')
func changeOpt(a):
	options[cur_select].set_opt(a)
	value.text = options[cur_select].display_opt()
