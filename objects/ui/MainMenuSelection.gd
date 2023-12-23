@tool
extends ColorRect

@export var option_name:String = 'Play'
		
func _ready():
	$img.set_texture(load('res://images/mm_' + option_name.to_lower()+ '.png'))
	$Label.text = option_name
