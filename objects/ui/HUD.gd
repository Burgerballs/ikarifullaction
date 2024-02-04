extends CanvasLayer

var score:
	get:
		return get_parent().score
func update():
	$Score.text = 'Score: '+str(score)
