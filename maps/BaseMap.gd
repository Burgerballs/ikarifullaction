@tool
class_name BaseMap
extends Node2D

@export var bgm:AudioStream
func _ready():
	Globals.play_music(bgm)
