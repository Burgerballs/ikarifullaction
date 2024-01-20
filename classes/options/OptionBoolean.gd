class_name OptionBoolean
extends OptionBase

var value:bool

func _ready():
	type = OptionTypes.OptionType.BOOLEAN
	value = Settings.get(option_name)

func set_opt(amount):
	Settings.set(option_name, !value)
	value = Settings.get(option_name)
	Settings.save_settings()
	
func display_opt():
	value = Settings.get(option_name)
	return '> '+ str(value)+' <'
