class_name PurpleHorseVirus
extends Enemy
var time = 0
var horseSpeed = 1
var flippingthisfaggot = true

#Code was wrote by null/raven so dont complain to the rest of the devs about slurs in source!! boohooo the faggot word is in my ikari...

func _physics_process(delta):
	time += delta
	position.y = cos(time * 6.3) * 1
	rotation = cos(time * 3.5) * 0.2
	
	if flippingthisfaggot:
		position.x -= horseSpeed
		scale = Vector2(0.9,0.9)
	else:
		position.x += horseSpeed
		scale = Vector2(-0.9,0.9)
		
	if position.x > 736:
		flippingthisfaggot = true
		print("horseflip")
	elif position.x < -128:
		flippingthisfaggot = false
		print("!horseflip")
