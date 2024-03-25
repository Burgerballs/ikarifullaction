extends CanvasLayer

var score:
	get:
		return get_parent().score
var coins:
	get:
		return get_parent().coins
func update():
	$Score.text = 'Awesomeness Points: '+str(score)
	$"CoinCounter/Label".text = 'x'+str(coins)
