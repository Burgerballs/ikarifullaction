extends CanvasLayer


@onready var comboLabel = $CanvasModulate/ComboLabel
@onready var comboBump = $CanvasModulate/ComboLabel/AnimationPlayer
@onready var comboPointLabel = $CanvasModulate/ComboLabel/Label
var score:
	get:
		return get_parent().score
var coins:
	get:
		return get_parent().coins

func update():
	$CanvasModulate/Score.text = 'Awesomeness Points: '+str(score)
	$"CanvasModulate/CoinCounter/Label".text = 'x'+str(coins)
