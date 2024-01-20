class_name OptionBase
extends Resource
var type:OptionTypes.OptionType
@export var option_screen_name:String
@export var option_name:String
@export_multiline var option_description:String = 'Placeholder'
func display_opt():
	pass # override this
func set_opt(amount):
	pass
