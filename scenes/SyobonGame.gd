extends Node2D
var player = "Ikari"
var playerChar
@onready var playerCam = $"PlayerCamera"
var map:BaseMap
var lockCameraX = false
var lockCameraY = false
var lockPos = Vector2(7,-87)
func _ready():
	map = load("res://maps/"+Globals.currentLevel+".tscn").instantiate()
	var playerPos = map.find_child('PlayerSpawn').position
	add_child(map)
	playerChar = load('res://objects/players/' +player+ '.tscn').instantiate()
	add_child(playerChar)
	playerChar.position = playerPos
func _physics_process(delta):
	playerCam.position.x = playerChar.position.x if !lockCameraX else lockPos.x
	playerCam.position.y = playerChar.position.y if !lockCameraY else lockPos.y
func kill():
	Globals.play_sound('die')
	Globals.music.stop()
	playerChar.kill()
	var tim = Timer.new()
	add_child(tim)
	tim.autostart = false
	tim.connect('timeout', func():
		Globals.enter_level(Globals.currentLevel))
	tim.start(3)
