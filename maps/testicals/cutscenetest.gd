extends BaseMap
@onready var ikari_actor = $Ikari_Skinwalker
var cutscenes:Dictionary = {
	'purple-horse' = [
		[
			0.0, 
			func(): 
				ikari_actor.position = game.playerChar.position 
				game.playerChar.visible = false
				ikari_actor.velocity = game.playerChar.velocity,
					
		],
		[
			1.0, 
			func(): ikari_actor.walk_to(120,'add')
		],
	]
}

func post_ready():
	game.start_cutscene(cutscenes['purple-horse'])
func doThing(c):
	match (c):
		0:
			ikari_actor.position = game.playerChar.position
