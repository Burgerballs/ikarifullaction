@tool
class_name Coin
extends Sprite2D
@onready var animPlayer = $AnimationPlayer
@onready var game = $'../../'
func on_trigger(a,b):
	collect()

@export var animSwap = false
func _on_animation_player_animation_finished(anim_name):
	animSwap = !animSwap
	if animSwap:
		animPlayer.play('spin')
	else:
		animPlayer.play('face'+str(randi_range(1,4)))
func block():
	var tweenUP = create_tween().set_ease(Tween.EASE_OUT)
	tweenUP.set_trans(Tween.TRANS_EXPO)
	tweenUP.tween_callback(collect)
	tweenUP.tween_property(self, 'position', Vector2(position.x,position.y - 15), 1)
	tweenUP.play()
	
func collect():
	Globals.play_sound('coin')
	game.set('coins', game.get('coins')+1)
	game.set('score', game.get('score')+50)
	queue_free()
