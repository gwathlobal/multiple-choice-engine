extends Node

class_name Save_Load

const SAVE_GAME_PATH:String = "user://saves/"

const main_settings:Main_Settings = preload("res://game/settings/main_settings.tres") as Main_Settings

static func get_files_at_save_dir() -> PackedStringArray:
	if not DirAccess.dir_exists_absolute(SAVE_GAME_PATH):
		DirAccess.make_dir_absolute(SAVE_GAME_PATH)
	return DirAccess.get_files_at(SAVE_GAME_PATH)

static func new_game(world:World) -> void:
	world.rng.randomize()
	
	# set up req fields
	world.system.clear()
	world.player.clear()
	
	for init_value in main_settings.initial_action_values:
		var obj = World._determine_object(init_value.obj)
		world.set_prop(obj, init_value.quality, init_value.value)
	
	world.initial_action = main_settings.initial_action

static func save_game(filename:String, world:World) -> void:
	var save:Dictionary = {}
	save["is_cur_action"] = world.is_cur_action
	save["cur_panel"] = world.cur_panel
	if !world.is_cur_action:
		save["actual_result"] = _prepare_actual_result_for_save(world.GUI.result_panel.result)
	save["system"] = _prepare_quality_for_save(world.system)
	save["player"] = _prepare_quality_for_save(world.player)
	
	if not DirAccess.dir_exists_absolute(SAVE_GAME_PATH):
		DirAccess.make_dir_absolute(SAVE_GAME_PATH)
	var saved_game = FileAccess.open(SAVE_GAME_PATH+filename, FileAccess.WRITE)
	var json_str = JSON.stringify(save)
	saved_game.store_line(json_str)

static func load_game(filename:String, world:World) -> void:
	if not FileAccess.file_exists(SAVE_GAME_PATH+filename):
		return
	var saved_game = FileAccess.open(SAVE_GAME_PATH+filename, FileAccess.READ)
	while saved_game.get_position() < saved_game.get_length():
		var json_string = saved_game.get_line()
		
		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		# Get the data from the JSON object
		var save = json.get_data()
		
		world.is_cur_action = save.get("is_cur_action")
		world.cur_panel = save.get("cur_panel")
		if !world.is_cur_action:
			world.GUI.result_panel.result = _prepare_actual_result_after_load(save.get("actual_result"))
		world.system = _prepare_quality_after_load(save.get("system"))
		world.player = _prepare_quality_after_load(save.get("player"))
		
	world.emit_signal("quality_changed")
	if !world.is_cur_action:
		world.go_to_result(world.GUI.result_panel.result) 

static func _prepare_quality_for_save(collection:Dictionary) -> Dictionary:
	var result:Dictionary = {}
	for prop_name in collection.keys():
		var prop_name_str:String = GQ.get_str(prop_name)
		result[prop_name_str] = collection[prop_name]
	return result

static func _prepare_quality_after_load(collection:Dictionary) -> Dictionary:
	var result:Dictionary = {}
	for prop_name_str in collection.keys():
		var prop_name:GQ.Nms = GQ.get_from_str(prop_name_str)
		result[prop_name] = collection[prop_name_str]
	return result

static func _prepare_actual_result_for_save(actual_result:Actual_Result) -> Dictionary:
	return actual_result.convert_to_dict()

static func _prepare_actual_result_after_load(dict:Dictionary) -> Actual_Result:
	return Actual_Result.build_from_dict(dict)
