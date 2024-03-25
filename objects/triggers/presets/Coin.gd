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
var blocking = false
func _physics_process(delta):
	if blocking:
		position.y-=delta*Globals.diffPhysicsProc*200
func block():
	blocking = true
	await get_tree().create_timer(0.2).timeout
	collect()
	
func collect():
	Globals.play_sound('coin')
	game.set('coins', game.get('coins')+1)
	game.set('score', game.get('score')+50)
	queue_free()
