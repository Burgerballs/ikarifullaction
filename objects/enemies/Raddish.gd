class_name Raddish
extends Enemy

## Fuckass direction changing
@onready var sprite = $AnimatedSprite2D
@onready var players = get_tree().get_nodes_in_group("player")
@export var direction = -1
@export var speedLimit = 100
func _ready():
	enemyType = 'raddish'
	connect('_on_hit_wall', func():
		direction = -direction
	)
func _physics_process(delta):
	super._physics_process(delta)
	sprite.flip_h = direction == 1
	sprite.offset.x = -30 if direction == 1 else 0
	applyForce(Vector2(240*delta*direction,0),20)
	if(abs(velocity.x) > speedLimit):
		velocity.x = speedLimit * direction;

#func _on_hurting_area_body_entered(body):
#	if body.velocity.y == 0:
#		print('im yo opp now cuz im hurtingn youuuu')
#		body.get_parent().KILL_them()
#	elif body.velocity.y > 0:
#		print('sdklsd')
#		emit_signal('_on_hit_by_player', self)
