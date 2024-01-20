class_name Player
extends PhysicsObject
var unmovable:bool = false
var flipped:bool = false
@onready var animPlayer = $"Sprite2D/AnimationPlayer"
@onready var sprite = $"Sprite2D"
@onready var hitbox = $"hitbox"
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
	else:
		sprite.flip_h = false
