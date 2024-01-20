extends Player
var speed = 5
var accel = 20
var friction = 2
var maximal
var speedMaximal = 300
var movingRate = 0
var holdGravMod = 1 # for when you hold the jump button, should make the jump a little more floaty!
var modifier = 1
var dashMod = 1
var airSuspension = false
var skidTimer = 0
var suspensionMult:
	get:
		return 1 if !airSuspension else 0
var jumping = false
@onready var animatedHitbox = $hitbox/AnimationTree
var isMoving:
	get:
		return directionVal != 0
var isGroundPound = false
var jumpMode = false
var crouching:
	get:
		return Input.is_action_pressed('down') && !isGroundPound
var prevFlipped # Stores the flipped value of the previous frame
func _physics_process(delta):
	super._physics_process(delta)
	skidTimer -= delta*1000
	sprite.position.x = 9 if flipped else -1
	# moving left and right code
	dashMod = 1.4 if Input.is_action_pressed('dash') else 1
	if prevFlipped != flipped && !jumping && !isGroundPound && is_on_floor() && !crouching && abs(movingRate) > 50: skidTimer = 172 # 6fps
	if isMoving:
		movingRate = Globals.bound(velocity.x + ((speed*(delta*100)*directionVal) * (friction*4) * dashMod), -speedMaximal * dashMod, speedMaximal * dashMod)
	else:
		movingRate /= (friction/1.5)
	if is_on_floor():
		if crouching:
			movingRate = 0
		if jumping:
			jumping = false
		if isGroundPound:
			isGroundPound = false
		if velocity.y == 0:
			jumpMode = false
	anim_handling()
	jump_handling()
	grund_pund()
	velocity.x = snapped(movingRate, 1) * modifier * suspensionMult
	gravity.y = (7 if Input.is_action_pressed('jump') && jumpMode else 10) * suspensionMult
	prevFlipped = flipped

func jump_handling():
	if Input.is_action_just_pressed('jump') && is_on_floor():
		var jumpMult = 1 if !crouching else 0.6
		velocity.y -= (430 * (abs((movingRate/speedMaximal)/15) + 1))*jumpMult
		jumpMode = true
		jumping = true
		animPlayer.play('jumpstart')
func grund_pund():
	if Input.is_action_just_pressed('down') && !is_on_floor() && !isGroundPound:
		isGroundPound = true
		airSuspension = true
		jumping = false
		jumpMode = false
		velocity = Vector2.ZERO
		animPlayer.play('groundpoundstart')
	if Input.is_action_just_pressed('jump') && !is_on_floor() && isGroundPound && airSuspension:
		poundattack()
		
func anim_handling():
	if isMoving && is_on_floor() && !crouching && skidTimer <= 0:
		animPlayer.play('walk')
	elif crouching:
		animPlayer.play('crouch')
	elif skidTimer > 0:
		animPlayer.play('turn')
	elif !isGroundPound && !jumping:
		animPlayer.play('idle')
	animatedHitbox.play('crouch' if crouching else 'RESET')


func _on_animation_player_animation_finished(anim_name):
	match(anim_name):
		'groundpoundstart':
			poundattack()
		'jumpstart':
			animPlayer.play('jump')
func poundattack():
		airSuspension = false
		animPlayer.play('groundpound')
		velocity.y += 430
