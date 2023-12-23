extends Node2D
@onready var swirl = $titleswirl
@onready var text = $titletext
func _process(delta):
	swirl.rotation += delta
	text.position.y = (sin(Globals.deltaCounter*2) * 10)
	text.rotation = (sin(Globals.deltaCounter/1.33)/10)
