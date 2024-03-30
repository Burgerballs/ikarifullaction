@tool
class_name BaseMap
extends Node2D

@export_category('Level Variables')
@export var bgm:AudioStream
@onready var game = $'../'
@export var start_floating:bool = false # if disabled, the player spawns on the object beneath the spawn object.

func _ready():
	Globals.play_music(bgm)
func on_trigger(c,p):
	match (c):
		'zoom':
			var zoom = float(p[0])
			get_parent().playerCam.zoom *= zoom
