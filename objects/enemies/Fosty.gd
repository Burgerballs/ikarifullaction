class_name Fosty
extends Enemy
@onready var spr = $Sprite2D
@onready var animplayer = $Sprite2D/AnimationPlayer
@onready var hbplayer = $collidingShape/AnimationPlayer
var movingRate = 130 # slightly fastor cuz shooe!!
@onready var game = $"../../"
var dead
@export var speed:float = -2.0 ## negative means left lol listen to my podcast
var shellshocked = false # your eejfjfmfdjewdoefnkfkn mom
var kicked = false
var prevMovingRate = 170
func _on__on_hit_wall(d = true):
	var glug = true
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group('enemy') && kicked:
			collision.get_collider().die()
			glug = false
			break
	if glug: speed *= -1
	if kicked && glug && d: Globals.play_sound('jumpBlock')
	
func _physics_process(delta):
	super._physics_process(delta)
	velocity.x = movingRate*speed*(1 if !shellshocked else 0 if !kicked else 2)
	spr.flip_h = !(velocity.x >= 1)
	edging()
func edging():
	if (!$edger1.is_colliding() or !$edger2.is_colliding()) && !shellshocked:
		position.x += 2 if !$edger1.is_colliding() else -2
		_on__on_hit_wall(false)

func _on_hurtbox_body_entered(body):
	if body.is_in_group('players'):
		if body.velocity.y > 0: #if player is going down
			# die(body)
			if body.isGroundPound:
				die()
			elif !shellshocked:
				shell(body)
			elif !kicked && shellshocked:
				kick(body)
				body.jump()
		elif !dead && (!shellshocked or kicked):
			game.kill()
		elif shellshocked && !kicked:
			kick(body)
func kick(e):
	kicked = true
	var direction = 1 if !e.flipped else -1
	speed = abs(speed) * direction
func die(_d = null):
	if _d:
		_d.jump()
	Globals.splodey(position + Vector2(-16, -15))
	dead = true
	game.score += 500
	queue_free()
func shell(d):
	d.jump()
	shellshocked = true
	animplayer.play("shell")
	hbplayer.play('shell')
