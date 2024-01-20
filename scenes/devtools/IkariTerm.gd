extends Node2D


func _on_text_edit_text_submitted(new_text):
	var params = new_text.split(' ')
	if params.size() != 2:
		params.append('')
	call(params[0], params[1])
	pass # Replace with function body.
func help(a):
	echo('play -level (eg; play world_1/level_1)')
func echo(a):
	$ColorRect/Label.text += '\n'+a
func play(a):
	Globals.enter_level(a)
