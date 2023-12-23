extends Node

var _cfg_file :ConfigFile
var _defaults :Dictionary = {}

const _CFG_PATH = "user://settings.cfg"

var limited_lives:bool = false # If set to false you are given a game over screen when the life counter goes below zero!
var enemy_speed:float = 1.0 # Sets how fast the enemies move, makes for some funny scenarios!
var score_counter:bool = false # Adds a score counter to the game!
var enemies_are_magnets:bool = false # You become uncontrollably attracted to the enemies when too close! BEWARE...
var triple_jump:bool = false # Adds a triple jump to the game, like the New Super Mario Bros games!
var auto_jump:bool = false # Makes it so you automatically jump immediately when touching the ground when holding JUMP, like original Syobon Action!
var outbreak_mode:bool = false # All of the enemies are now poison mushrooms!

var framerate_cap :int = 120:
	set(v): Engine.max_fps = v; framerate_cap = v
var vsync :bool = true:
	set(v):
		var vsync_mode := DisplayServer.VSYNC_ADAPTIVE if v == true else DisplayServer.VSYNC_DISABLED
		DisplayServer.window_set_vsync_mode(vsync_mode)
		vsync = v
		
var controls :Dictionary = {
	"up": ["W", "Up"],
	"left": ["A", "Left"],
	"down": ["S", "Down"],
	"right": ["D", "Right"],
	"jump": ['Space', 'Z'],
	"dash": ['Shift', 'X'],
	"enter": ['Enter', 'None'],
	"suicide": ['K', 'R']
}

func _ready() -> void:
	load_settings()


## Loads your settings file and sets settings to their respective values
func load_settings() -> void:
	if _cfg_file == null: _cfg_file = ConfigFile.new()

	_cfg_file.load(_CFG_PATH)
	

	var settings_keys :Array[Dictionary] = get_script().get_script_property_list()
	settings_keys.remove_at(0)

	for key in settings_keys:
		if key.name.begins_with("_"): continue
		_defaults[key.name] = get(key.name)

		if _cfg_file.has_section_key("Settings", key.name):
			var new_v = _cfg_file.get_value("Settings", key.name, get(key.name))
			set(key.name, new_v)
		else:
			_cfg_file.set_value("Settings", key.name, get(key.name))

	_refresh_controls()
	save_settings()

	_cfg_file.clear()
	_cfg_file.unreference()

## Saves the current state of your settings to your settings file
func save_settings() -> void:
	if _cfg_file == null:
		_cfg_file = ConfigFile.new()
		_cfg_file.load(_CFG_PATH)

	var settings_keys :Array[Dictionary] = get_script().get_script_property_list()
	settings_keys.remove_at(0)

	for key in settings_keys:
		if key.name.begins_with("_"): continue
		_cfg_file.set_value("Settings", key.name, get(key.name))

	_cfg_file.save(_CFG_PATH)
	print(FileAccess.file_exists(_CFG_PATH))

	_cfg_file.clear()
	_cfg_file.unreference()


func _refresh_controls() -> void:
	for key in controls:
		var main_event := InputEventKey.new()
		var alt_event := InputEventKey.new()

		var keys := InputMap.action_get_events(key)
		var binds :Array = controls[key]

		main_event.set_keycode(OS.find_keycode_from_string(binds[0].to_lower()))
		alt_event.set_keycode(OS.find_keycode_from_string(binds[1].to_lower()))

		if keys.size() - 1 != -1:
			for old in keys:
				# delete bind in case it exists (needed for binding new ones)
				InputMap.action_erase_event(key, old)
		else:
			# or just add if it doesn't
			InputMap.add_action(key)

		# then bind the new ones
		InputMap.action_add_event(key, main_event)
		InputMap.action_add_event(key, alt_event)
