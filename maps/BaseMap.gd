@tool
class_name BaseMap
extends Node2D

@export var bgm:AudioStream
func _ready():
	Globals.play_music(bgm)
func on_trigger(c,p):
	match (c):
		'zoom':
			var zoom = float(p[0])
			get_parent().playerCam.zoom *= zoom
