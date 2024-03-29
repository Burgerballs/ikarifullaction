extends Node2D
@onready var backSpr = $Portalfront
@onready var frontSpr = $Portalback
@onready var game = $'../../'
var won = false
func win():
	get_tree().paused = true
	Globals.play_sound('win', 1, 0, 0.5)
	$CPUParticles2D2.visible = true
	await get_tree().create_timer(5).timeout
	Globals.transitioner.play("mosaic-in")
func _physics_process(delta):
	backSpr.rotation += delta
	frontSpr.position.y = (sin(Globals.deltaCounter*2) * 5)
	frontSpr.rotation = (sin(Globals.deltaCounter/1.33)/5)
	var diff = (game.playerChar.position - position) / 100
	$Control.material.set_shader_parameter('outRadius', -(diff.x))
	game.find_child('HUD').find_child('CanvasModulate').modulate.a = -(diff.x)
	Globals.music.volume_db = -80 if $Control.material.get_shader_parameter('outRadius') <= 0 else 0
	if $Control.material.get_shader_parameter('outRadius') <= 0 && !won:
		won = true
		win()
