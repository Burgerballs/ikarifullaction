extends Player
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
@onready var animatedHitbox = $hitbox/AnimationTree
@onready var hitboxShapeSize = $hitbox.shape.size
var isMoving:
	get:
		return directionVal != 0
var isGroundPound = false
var jumpMode = false
var crouching:
	get:
		return Input.is_action_pressed('down') && !isGroundPound
var prevFlipped # Stores the flipped value of the previous frame

var prevOnGround = false # we are getting really fucky with variables so why not
func _physics_process(delta):
	super._physics_process(delta)
	if (!dead):
		skidTimer -= delta*1000
		hitwallTimer -= delta *1000
		coyoteTimer -= delta *1000
		sprite.position.x = 1 if flipped && !tripState else -1
		if tripState or hitwall:
			flipped = prevFlipped
			sprite.flip_h = flipped
		# moving left and right code
		dashMod = 1.4 if Input.is_action_pressed('dash') else 1
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
		if Input.is_action_just_pressed('jump') && (is_on_floor() or coyoteTimer > 0):
			jump()
			Globals.play_sound('jump', 1 if is_on_floor() && !crouching else 1.05 if coyoteTimer > 0 else 1.2)
		grund_pund()
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
	if !tripState:
		animPlayer.play('jumpstart')
func grund_pund():
	if Input.is_action_just_pressed('down') && !is_on_floor() && !isGroundPound && !tripState:
		isGroundPound = true
		airSuspension = true
		jumping = false
		jumpMode = false
		velocity = Vector2.ZERO
		animPlayer.play('groundpoundstart')
	if Input.is_action_just_pressed('jump') && !is_on_floor() && isGroundPound && airSuspension:
		poundattack()
		
func anim_handling():
	if isMoving && is_on_floor() && !crouching && skidTimer <= 0 && !tripState && !hitwall:
		animPlayer.play('walk')
	elif crouching && !tripState && !hitwall:
		animPlayer.play('crouch')
	elif skidTimer > 0 && !tripState && !hitwall:
		animPlayer.play('turn')
	elif !isGroundPound && !jumping && !tripState && !hitwall:
		animPlayer.play('idle')
	animatedHitbox.play("spin" if tripState && !crouching else 'crouch' if crouching && !tripState else 'RESET')


func _on_animation_player_animation_finished(anim_name):
	match(anim_name):
		'groundpoundstart':
			poundattack()
		'jumpstart':
			animPlayer.play('jump')
		'trip':
			animPlayer.play('trip2')
		'trip2':
			animPlayer.play('spin')
		'wallhit':
			animPlayer.play('wallfall')
func poundattack():
		airSuspension = false
		animPlayer.play('groundpound')
		velocity.y += 430
func trip():
	tripState = true
	velocity.y -= 230 if velocity.y == 0 else 0
	animPlayer.play('trip')
func kill():
	dead = true
	enablePhysics = false
	animPlayer.play('death')
	collision_layer = 1
	collision_mask = 1
	var tim = Timer.new()
	add_child(tim)
	tim.autostart = false
	tim.connect('timeout', func():
		enablePhysics = true
		velocity.x = 0
		velocity.y = -500
		Globals.play_music(load('res://audio/bgm/BGM_die.ogg'))
		tim.stop())
	tim.start(1)
