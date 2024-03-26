extends Node
class_name HighScores
class ScoreData:
	var score:int = 0
	var time:float = 0
	var rank:String = ':3'
	var vanquishments:int = 0
	func _init(score:int = 0, time:float = 0, rank:String = ':3', vanquishments:int = 0):
		self.score = score
		self.time = time
		self.rank = rank
		self.vanquishments = vanquishments
		
static var saveVersion = 'DEMO' # so demo save data doesn't carry over to the newer versions
static var _CFG_PATH = "user://"+saveVersion+'save.cfg'
static func save_score(data: ScoreData, level:String):
	if get_score(level).score > data.score:
		return
	
	var conf: = ConfigFile.new()
	
	# TODO: ENCRYPT THIS LATER :3
	conf.load(_CFG_PATH)
	conf.set_value('levels', level, data)
	conf.save(_CFG_PATH)
	
	conf.clear()
	conf.unreference()

static func get_score(level: String):
	var conf: = ConfigFile.new()
	conf.load(_CFG_PATH)
	if conf.has_section_key('levels', level):
		var value = conf.get_value('levels', level)
		conf.unreference()
		return value
	return ScoreData.new()
