class_name Enemy
extends PhysicsObject
signal _on_hit_wall()
signal _on_hit_player()
signal _on_hit_by_player(enemy)
var enemyType = ''
var airborne = false
func _physics_process(delta):
	super._physics_process(delta)
	if is_on_wall():
		_on_hit_wall.emit()
	airborne = !is_on_wall() && !is_on_ceiling() && !is_on_floor()
