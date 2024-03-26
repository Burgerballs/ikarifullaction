extends BaseMap
@onready var game = $'../'
func on_trigger(a,b):
	match a:
		'lock_cam':
			var lock = b[0]
			if lock:
				Globals.transitioner.play('mosaic-in')
			else:
				Globals.transitioner.play('mosaic-out')
			var lockType = b[1]
			game.lockPos.x = game.playerChar.position.x
			game.lockPos.y = game.playerChar.position.y
			match lockType:
				'x':
					game.lockCameraX = lock
				'y':
					game.lockCameraY = lock
				'xy':
					game.lockCameraY = lock
					game.lockCameraX = game.lockCameraY
