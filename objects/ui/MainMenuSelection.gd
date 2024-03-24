@tool
extends ColorRect

@export var option_name:String = 'Play'
@export_multiline var description:String = 'This is awesome'
func _ready():
	$img.set_texture(load('res://images/mm_' + option_name.to_lower()+ '.png'))
	$Label.text = option_name
