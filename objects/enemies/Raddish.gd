class_name Raddish
extends Enemy
@onready var spr = $Sprite2D
var movingRate = 20
@onready var game = $"../../"
@export var speed:float = -2.0 ## negative means left lol listen to my podcast
func _on__on_hit_wall():
	movingRate *= -1
	
func _physics_process(delta):
	super._physics_process(delta)
	velocity.x = movingRate*speed
	spr.flip_h = velocity.x >= 1


func _on_hurtbox_body_entered(body):
	if body.is_in_group('players'):
		if body.velocity.y < 0: #if player is going down
			body.jump()
			die()
		else:
			game.kill()
func die():
	queue_free()
