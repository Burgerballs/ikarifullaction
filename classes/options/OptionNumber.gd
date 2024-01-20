class_name OptionNumber
extends OptionBase

var value
@export var min_max:Vector2 = Vector2(1,4)
@export var add_amount:float = 1
@export var suffix:String = ''

func _ready():
	type = OptionTypes.OptionType.NUMBER
	value = Settings.get(option_name)
func set_opt(amount):
	Settings.set(option_name, wrap(value+(amount*add_amount), min_max.x, min_max.y+1))
	Settings.save_settings()
	value = Settings.get(option_name)
	print(value)
func display_opt():
	value = Settings.get(option_name)
	return '< '+ str(value) + suffix + ' >'
