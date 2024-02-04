class_name Raddish
extends Enemy
@onready var spr = $Sprite2D
@onready var animplayer = $Sprite2D/AnimationPlayer
var movingRate = 120
@onready var game = $"../../"
var dead
@export var speed:float = -2.0 ## negative means left lol listen to my podcast
func _on__on_hit_wall():
	speed *= -1
	
	
func _physics_process(delta):
	super._physics_process(delta)
	movingRate = 0 if animplayer.current_animation == 'bite' else 20
	velocity.x = movingRate*speed
	spr.flip_h = velocity.x >= 1


func _on_hurtbox_body_entered(body):
	if body.is_in_group('players'):
		if body.velocity.y > 0: #if player is going down
			die(body)
		elif !dead:
			animplayer.play("bite")
			game.kill()
			
func die(_d = null):
	if _d:
		_d.jump()
	Globals.splodey(position + Vector2(-16, -15))
	dead = true
	queue_free()
	game.score+=350


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'bite':
		animplayer.play('spin')
	pass # Replace with function body.
