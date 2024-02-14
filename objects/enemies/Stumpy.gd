class_name Stumpy
extends Enemy
@onready var spr = $Sprite2D
@onready var animplayer = $Sprite2D/AnimationPlayer
@onready var hbplayer = $collidingShape/AnimationPlayer
var movingRate = 120
@onready var game = $"../../"
var dead
@export var speed:float = -2.0 ## negative means left lol listen to my podcast
var shellshocked = false # your eejfjfmfdjewdoefnkfkn mom
var prevMovingRate = 120
var transing = false
var thing:
	get:
		return ['b','g'].pick_random()
func _on__on_hit_wall():
	var glug = true
	if glug && !transing: speed *= -1
	
func _physics_process(delta):
	super._physics_process(delta)
	velocity.x = movingRate*speed*(1 if !shellshocked && !transing else 0)
	spr.flip_h = !(velocity.x >= 1)


func _on_hurtbox_body_entered(body):
	if body.is_in_group('players'):
		if body.velocity.y > 0: #if player is going down
			# die(body)
			if !shellshocked:
				shell(body)
		elif !dead && !transing:
			game.kill()
func die(_d = null):
	if _d:
		_d.jump()
	Globals.splodey(position + Vector2(-16, -15))
	dead = true
	queue_free()
func shell(d):
	transing = true # trans awakening
	d.jump()
	shellshocked = true # sudden realization
	animplayer.play(thing + '_trans') # transitioning begins
func _on_animation_player_animation_finished(anim_name):
	# she finished her transition im proud
	match anim_name:
		'b_trans':
			var transed = load("res://objects/enemies/Fosty.tscn").instantiate()
			$"../".add_child(transed)
			transed.position = position
			die()
		'g_trans':
			var transed = load("res://objects/enemies/Runny.tscn").instantiate()
			$"../".add_child(transed)
			transed.position = position
			die()
