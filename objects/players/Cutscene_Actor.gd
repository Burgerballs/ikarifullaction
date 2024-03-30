extends PhysicsObject
var speed = 5
var accel = 20
var friction = 2
var maximal
var speedMaximal = 300
var movingRate = 0
var coyoteTimer = 0 # fuck yeah!!
var holdGravMod = 1 # for when you hold the jump button, should make the jump a little more floaty!
var modifier = 1
var dashMod = 1
var airSuspension = false
var skidTimer = 0
var hitwallTimer = 0
var tripState = false
var dead = false
var hitwall:
	get:
		return hitwallTimer > 0
var suspensionMult:
	get:
		return 1 if !airSuspension else 0
var jumping = false
@onready var animPlayer = $Sprite2D/AnimationPlayer
@onready var animatedHitbox = $hitbox/AnimationTree
@onready var hitboxShapeSize = $hitbox.shape.size
@onready var sprite = $Sprite2D
var flipped = false
var directionVal = 0
var isMoving:
	get:
		return directionVal != 0
var isGroundPound = false
var jumpMode = false
var crouching = false
var prevFlipped # Stores the flipped value of the previous frame
var prevOnGround = false # we are getting really fucky with variables so why not

var walkToState = false
var walkToPos = 0
var walkToStartPos = 0
var walkToType = 'add'
var walkToDash = false
var walkToCalc:
	get:
		return -sign(walkToStartPos - walkToPos)
func walk_to(x_pos:float = 0, type:String = 'add', dash:bool = false):
	match type:
		'add':
			walkToStartPos = position.x
			walkToPos = position.x + x_pos
			walkToState = true
			walkToDash = dash
func _physics_process(delta):
	super._physics_process(delta)
	if (!dead):
		if walkToState:
			match walkToType:
				'add':
					directionVal = walkToCalc
					if isMoving:
						if position.x < walkToPos && directionVal == -1:
							walkToState = false
							directionVal = 0
						elif position.x > walkToPos && directionVal == 1: 
							walkToState = false
							directionVal = 0
		
		flipped = (directionVal<=-1)
		skidTimer -= delta*1000
		hitwallTimer -= delta *1000
		coyoteTimer -= delta *1000
		sprite.position.x = 1 if flipped && !tripState else -1
		if tripState or hitwall:
			flipped = prevFlipped
			sprite.flip_h = flipped
		# moving left and right code
		if prevFlipped != flipped && !jumping && !isGroundPound && is_on_floor() && !crouching && abs(movingRate) > 50: skidTimer = 172 # 6fps
		if isMoving && !tripState && !hitwall:
			movingRate = Globals.bound(velocity.x + ((speed*(delta*100)*directionVal) * (friction*4) * dashMod), -speedMaximal * dashMod, speedMaximal * dashMod)
		elif tripState:
			movingRate = 570 * (-1 if flipped else 1)
		else:
			movingRate /= (friction/1.5)
		if is_on_floor():
			if crouching && !tripState:
				movingRate = 0
			if jumping:
				jumping = false
			if isGroundPound:
				movingRate*=1.4
				isGroundPound = false
			if velocity.y == 0:
				jumpMode = false
		if is_on_wall():
			if tripState:
				tripState = false
				hitwallTimer = 667
				movingRate = 760 * -(-1 if flipped else 1)
				velocity.y -= 230
				animPlayer.play('wallhit')
		anim_handling()
		if is_on_wall(): # move player over
			if hitwall:
				position.x -= hitboxShapeSize.x * (-1 if flipped else 1) / 4
		
		velocity.x = snapped(movingRate, 1) * modifier * suspensionMult
		gravity.y = (7 if Input.is_action_pressed('jump') && jumpMode else 10) * suspensionMult
		prevFlipped = flipped
		if prevOnGround && !is_on_floor() && !jumping:
			coyoteTimer = 132 # 0.132 seconds!
		prevOnGround = is_on_floor()
	else:
		sprite.flip_h = false
func jump():
	var jumpMult = 1 if !crouching else 0.6
	velocity.y = 0
	velocity.y -= (430 * (abs((movingRate/speedMaximal)/15) + 1))*jumpMult
	jumpMode = true
	jumping = true
	Globals.play_sound('jump', 1 if is_on_floor() && !crouching else 1.05 if coyoteTimer > 0 else 1.2)
	if !tripState:
		animPlayer.play('jumpstart')
func grund_pund():
	isGroundPound = true
	airSuspension = true
	jumping = false
	jumpMode = false
	velocity = Vector2.ZERO
	animPlayer.play('groundpoundstart')
func anim_handling():
	if isMoving && is_on_floor() && !crouching && skidTimer <= 0 && !tripState && !hitwall:
		animPlayer.play('walk')
	elif !isGroundPound && !jumping && !tripState && !hitwall:
		animPlayer.play('idle')
