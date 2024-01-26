@tool
class_name BoomboxFlower
extends Sprite2D
@onready var game = $'../../'
@onready var animPlayer = $AnimationPlayer
func on_trigger(a,b):
	print('sdijf')
	match a:
		'trip':
			animPlayer.play("hey!")
			game.playerChar.trip()


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		'hey!':
			animPlayer.play('oh')
		'oh':
			animPlayer.play("stare")
