class_name Player
extends PhysicsObject

enum PlayerStates {
	STATE_IDLE,
	STATE_WALK,
	STATE_TRIP,
	STATE_TRIP2,
	STATE_ROLLING,
	STATE_PREPARING_GROUND_POUND,
	STATE_GROUND_POUND,
	STATE_FALLING,
	STATE_TAUNT,
	STATE_DIE,
	STATE_CROUCH,
	STATE_STEROIDSANIM,
	STATE_STEROIDS
}
var canJump = true
var stuck:bool = false
var currentState:PlayerStates = PlayerStates.STATE_IDLE
var nuVelocity:Vector2 = Vector2.ZERO
var speed:float = 200
var jumpHeight:float = 1.9;
var isCrouching:float = false
var speedLimit:float = 250;
var unmovable:bool = false
@onready var animPlayer = $"Sprite2D/AnimationPlayer"
@onready var sprite = $"Sprite2D"
var flipped:bool = false
var slipperyVel:bool = false # Turning this on makes it to the velocity doesn't change when there is no directional input, basically, ice physics!
var directionVal:int:
	get:
		if Input.is_action_pressed('left') && !Input.is_action_pressed('right') && !unmovable:
			return -1
		elif Input.is_action_pressed('right') && !Input.is_action_pressed('left') && !unmovable:
			return 1
		elif Input.is_action_pressed('right') && Input.is_action_pressed('left') or !Input.is_action_pressed('right') && !Input.is_action_pressed('left') or unmovable:
			return 0
		return 0
		
func _physics_process(delta):
	super._physics_process(delta)
	if (directionVal != 0):
		flipped = directionVal < 0
	if flipped:
		sprite.flip_h = true
		sprite.position.x = 8
	else:
		sprite.flip_h = false
		sprite.position.x = -1
	applyForce(Vector2(speed*delta*directionVal,0),20)
	
	if is_on_floor() && !stuck:
		enablePhysics = true
		if Input.is_action_just_pressed('jump'):
			isJumping = true
			canJump = false
			animPlayer.play('jump')
			Globals.play_sound('jump')
			velocity.y-=250*jumpHeight+abs(0.3*velocity.x)
		elif directionVal != 0 && !is_on_wall():
			animPlayer.play('walk')
		elif Input.is_action_pressed('down'):
			unmovable = true
			animPlayer.play('crouch')
		else:
			canJump = true
			animPlayer.play('idle')
			unmovable = false
	elif !is_on_floor() && !stuck:
		if Input.is_action_just_pressed('down'):
			animPlayer.play('groundpoundstart')
			stuck = true
	if stuck:
		velocity = Vector2.ZERO
	var specialLimit = speedLimit * (1.2 if Input.is_action_pressed('dash') else 1)
	if(abs(velocity.x) > specialLimit):
		velocity.x = specialLimit * directionVal;
	
	if (directionVal == 0):
		velocity.x = lerpf(velocity.x, 0, Globals.bound(20*delta,0,1))
			

func killSequence():
	Globals.music.stop()
	Globals.play_sound('die')
	unmovable = true
	stuck = true
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	animPlayer.play('death')
	collision_layer = 0
	collision_mask = 0
	velocity = Vector2.ZERO
	gravity = Vector2(0,0)
	timer.connect('timeout', func():
		gravity = Vector2(0,10)
		stuck = false
		velocity.y = -500
		Globals.play_music(load("res://audio/bgm/BGM_die.ogg"))
	)
	timer.start(1)

	
func _on_animation_player_animation_finished(anim_name):
	match (anim_name):
		'groundpoundstart':
			stuck = false
			animPlayer.play('groundpound')
			velocity.y = 650
