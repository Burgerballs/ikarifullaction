extends CanvasLayer

@onready var options = $"Panel2/VBoxContainer".get_children()
var curSelected = 0
func _ready():
	get_tree().paused = true
	changeSel(0)
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.volume_db = -40
	create_tween().tween_property($AudioStreamPlayer, 'volume_db', 0, 0.5)
func _unhandled_key_input(event):
	if Input.is_action_just_pressed('up'):
		changeSel(-1)
	if Input.is_action_just_pressed('down'):
		changeSel(1)
	if Input.is_action_just_pressed('enter'):
		match curSelected:
			0:
				await get_tree().create_timer(0.1).timeout
				get_tree().paused = false
				queue_free()
			1:
				get_tree().paused = false
				Globals.transition_scene('res://scenes/SyobonTitle.tscn')
func changeSel(a):
	curSelected = wrap(curSelected+a, 0, options.size())
	for i in options:
		i.modulate = Color(0.5,0.5,0.5,1)
	options[curSelected].modulate = Color(1,1,1,1)
	if a != 0:
		Globals.play_sound('jumpBlock')
