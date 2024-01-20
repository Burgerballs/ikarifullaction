@tool
class_name PhysicsObject
extends CharacterBody2D
var lifetime:float
var enablePhysics = true
var gravity = Vector2(0, 10)
var gravityDefault = Vector2(0, 10)
var snapToGround = false
var previousVelocity = Vector3.ZERO
func _physics_process(delta):
	if (enablePhysics):
		lifetime += delta

		#If we're not on the ground, add gravity
		if (!is_on_floor() || !snapToGround):
			velocity.y += (gravity.y/Globals.diffPhysicsProc);
		elif (velocity.y != 0):
			velocity.y = 0;

		#If we're running into a wall, don't build up force
		if (is_on_wall() && sign(velocity.x) == sign(previousVelocity.x)): velocity.x = 0;

		#If we're running into a ceiling, don't build up force
		if (is_on_ceiling() && sign(velocity.y) == sign(previousVelocity.y)): velocity.y = 0;
		move_and_slide()
		previousVelocity = velocity;
func applyForce(direction:Vector2, speed:float):
	var normalized = direction.normalized();
	var force = normalized * speed
	velocity.x += force.x
	velocity.y += force.y
