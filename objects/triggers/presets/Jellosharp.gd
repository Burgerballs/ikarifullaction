@tool
## He's homosexual, but you already know that.
class_name Jellosharp
extends Sprite2D

@onready var game = $'../../'
@export_multiline var text = 'Press Z or the Spacebar to Jump! Tap with the elegance of a ballerina to make a small hop, or hold with the strength of a firm stomp to challenge the rules of gravity!'
@onready var label = $Sprite2D/Label
@onready var jelloboxAnim = $Sprite2D/AnimationPlayer
@onready var jellobox = $Sprite2D
@onready var animPlayer = $AnimationPlayer
@export var textSpeed = 25 # the amount of time in milliseconds a single glyth should take to appear
var talkin = false
func on_trigger(a,b):
	pass
func _ready():
	label.text = text
	jellobox.visible = false
	label.visible_ratio = 0
	
var jelloTimer = 0
func _process(delta):
	if talkin:
		jelloTimer+=delta*1000
		if jelloTimer >= textSpeed:
			jelloTimer = 0
			if label.visible_characters != text.length():
				label.visible_characters += 1

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		'close':
			talkin = false
			jellobox.visible = false
		'open':
			talkin = true
			jelloboxAnim.play('speaking')


func _on_visible_on_screen_notifier_2d_screen_entered():
	animPlayer.play('hecomes')


func _on_visible_on_screen_notifier_2d_screen_exited():
	animPlayer.play('where')


func _on_map_caller_body_entered(body):
	if (body == game.get('playerChar')):
		animPlayer.play('dance')
		jellobox.visible = true
		jelloboxAnim.play('open')
	pass # Replace with function body.


func _on_map_caller_body_exited(body):
	if (body == game.get('playerChar')):
		animPlayer.play('standing')
		jelloboxAnim.play('close')
		talkin = false
		label.visible_ratio = 0
	pass # Replace with function body.
