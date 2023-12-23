extends Node2D

@onready var player = $Player
@onready var playerCam = $"PlayerCamera"
var map
var lockCameraX = false
var lockCameraY = true
var lockPos = Vector2(7,-87)
func _ready():
	map = load("res://maps/"+Globals.currentLevel+".tscn").instantiate()
	add_child(map)
func process_enemy_collide(enemy):
	match(enemy.enemyType):
		'raddish':
			if player.velocity.y >= 10:
				var spaceMult = 1.1 if Input.is_action_pressed('jump') else 1
				player.canJump = false
				player.animPlayer.play('jump')
				player.velocity.y = 0
				player.velocity.y -= 350 *spaceMult
				enemy.queue_free()
			else:
				KILL_them()
func _physics_process(delta):
	playerCam.position.x = player.position.x if !lockCameraX else lockPos.x
	playerCam.position.y = player.position.y if !lockCameraY else lockPos.y
	if player.is_on_ceiling():
		Globals.play_sound('jumpBlock')
	for e in player.get_slide_collision_count():
		var obj = player.get_slide_collision(e).get_collider()
		if obj != null && obj.is_in_group('enemy'):
			player.canJump = false
			process_enemy_collide(obj)
func KILL_them():
	print('muahahha i am the game and i kill u now')
	playerCam.position_smoothing_enabled = false
	Globals.music.connect('finished', func():
		print('restart screen will be here')
		pass)
	player.killSequence()
