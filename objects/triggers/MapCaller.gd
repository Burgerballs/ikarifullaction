@tool
class_name MapCaller
extends Area2D

@export var call_name:String = ''
@export var params:Array = []
@export var one_shot:bool = true
func _ready():
	connect("body_entered", _on_body_entered)
var alreadyDid = false
func _on_body_entered(body):
	if body.is_in_group('players'):
		if one_shot == false || alreadyDid == false:
			get_parent().call('on_trigger', call_name, params)
		alreadyDid = true
