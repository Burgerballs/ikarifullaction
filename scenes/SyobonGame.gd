extends Node2D
var player = "Ikari"
var playerChar
@onready var playerCam = $"PlayerCamera"
var map:BaseMap
var lockCameraX = false
var lockCameraY = false
var lockPos = Vector2(7,-87)
var score:int = 0
var coins:int = 0
func _ready():
	map = Globals.levelCached.instantiate()
	var playerPos = map.find_child('PlayerSpawn').position
	if map.find_child('CameraArea'):
		var cameraBounds = map.find_child('CameraArea')
		playerCam.limit_bottom = cameraBounds.global_position.y + cameraBounds.size.y
		playerCam.limit_top = cameraBounds.global_position.y
		playerCam.limit_right = cameraBounds.global_position.x + cameraBounds.size.x
		playerCam.limit_left = cameraBounds.global_position.x
	add_child(map)
	playerChar = load('res://objects/players/' +player+ '.tscn').instantiate()
	add_child(playerChar)
	playerChar.position = playerPos
func _physics_process(delta):
	playerCam.position.x = playerChar.position.x if !lockCameraX else lockPos.x
	playerCam.position.y = playerChar.position.y if !lockCameraY else lockPos.y
func _unhandled_key_input(event):
	if Input.is_action_just_pressed('enter'):
		add_child(load("res://scenes/IkariPause.tscn").instantiate())
func _process(delta):
	$HUD.update()
func kill():
	Globals.play_sound('die')
	lockPos.x = playerChar.position.x if !lockCameraX else lockPos.x
	lockPos.y = playerChar.position.y if !lockCameraY else lockPos.y
	lockCameraX = true
	lockCameraY = true
	Globals.music.stop()
	playerChar.kill()
	var tim = Timer.new()
	add_child(tim)
	tim.autostart = false
	tim.connect('timeout', func():
		get_tree().reload_current_scene())
	tim.start(3)
