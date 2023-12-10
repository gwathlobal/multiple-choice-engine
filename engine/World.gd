extends Node

var GUI:Control

var quals:Dictionary = {}

var actions:Dictionary = {}
var results:Dictionary = {}
var postprocs:Dictionary = {}

var system:Dictionary = {}
var player:Dictionary = {}

var is_cur_action:bool = true
var cur_panel:String

var initial_action:String

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

var avail_declinations:Array[String] = [ 
		"sg_nom", "sg_gen", "sg_dat", "sg_acc", "sg_inst", "sg_prep", 
		"pl_nom", "pl_gen", "pl_dat", "pl_acc", "pl_inst", "pl_prep"
	] 

signal quality_changed
signal gui_connected

func _ready():
	# try to load the game from file(s)
	_init_game()
	
	# load translations manually
	_load_translations()
	
	# load qualities
	var dir:PackedStringArray = DirAccess.get_files_at("res://game/qualities")
	for filename in dir:
		filename = filename.trim_suffix(".remap")
		var quality:Game_Quality = ResourceLoader.load("res://game/qualities/" + filename)
		quals[quality.id] = quality
	
	# load actions
	dir = DirAccess.get_files_at("res://game/actions")
	for filename in dir:
		if filename == ".todelete":
			continue
		filename = filename.trim_suffix(".remap")
		var action = ResourceLoader.load("res://game/actions/" + filename) as Game_Action
		if action.id == null or action.id == "":
			action.id = filename.trim_suffix(".tres")
		if actions.has(action.id):
			push_warning("An action with id %s is already present in the action list. Make sure there is no error here." % action.id) 
		actions[action.id] = action
		
		for option in action.options:
			if option.result_success != null:
				results[option.result_success.id] = option.result_success
			if option.result_fail != null:
				results[option.result_fail.id] = option.result_fail
	
	# load post procs
	dir = DirAccess.get_files_at("res://game/postprocs")
	for filename in dir:
		if filename == ".todelete":
			continue
		filename = filename.trim_suffix(".remap")
		var postproc = ResourceLoader.load("res://game/postprocs/" + filename) as Game_PostProc 
		postprocs[filename] = postproc
		
		if postproc.result != null:
				results[postproc.result.id] = postproc.result
	
	Save_Load.new_game(self)

func _init_game():
	# load the config file first
	var config = ConfigFile.new()
	var err = config.load("res://config.cfg")
	
	if err != OK:
		push_error("Loading config.cfg failed! "+err)
		return
	
	var game_file = config.get_value("Game", "game_file")
	if game_file == null:
		push_error("Empty game file in config.cfg!")
		return
	
	var game_file_str = "res://"+game_file
	# load the game archive
	var success = ProjectSettings.load_resource_pack(game_file_str, true)
	if not success:
		push_error("Loading " + game_file + " failed!")
		return

func _load_translations():
	const TRANSLATION_DIRECTORY = "res://game/i18n"
	
	var dir = DirAccess.get_files_at(TRANSLATION_DIRECTORY)
	for filename in dir:
		if filename == ".todelete":
			continue
		if (".translation" in filename):
			var translation = load(TRANSLATION_DIRECTORY+"/"+filename) as Translation
			TranslationServer.add_translation(translation)

func set_prop(obj:Dictionary, prop_name:GQ.Nms, value: String) -> String:
	var old_value:String = obj.get(prop_name, "")
	obj[prop_name] = value
	if value.is_valid_int():
		var quality:Game_Quality = quals.get(prop_name)
		var c:int = value.to_int()
		if c < quality.min_value:
			c = quality.min_value
		if c > quality.max_value:
			c = quality.max_value
		obj[prop_name] = str(c)
	emit_signal("quality_changed")
	return old_value

func mod_prop(obj:Dictionary, prop_name:GQ.Nms, value: String, positive:bool = true):
	var quality:Game_Quality = quals.get(prop_name)
	if !value.is_valid_int():
		return
	if !obj.get(prop_name, "0").is_valid_int():
		return
	var v:int = value.to_int()
	if !positive:
		v = v * -1
	var c:int = obj.get(prop_name, "0").to_int()
	var old_value = str(c)
	c += v
	if c < quality.min_value:
		c = quality.min_value
	if c > quality.max_value:
		c = quality.max_value
	obj[prop_name] = str(c)
	emit_signal("quality_changed")
	return old_value

func get_prop(obj:Game_Command.Obj_Enum, prop_name:GQ.Nms):
	# determine object
	var _obj:Dictionary = _determine_object(obj)
	if _obj == null:
		push_error(obj, " does not reference a correct object")
		return ""
	
	var quality:Game_Quality = quals.get(prop_name)
	if quality == null:
		push_error(GQ.get_str(prop_name), " does not reference a correct quality")
		return ""
	
	return _obj.get(prop_name, "0") 

func get_quality_by_id(id:GQ.Nms) -> Game_Quality:
	return quals.get(id)

func _determine_object(obj:Game_Command.Obj_Enum):
	var result = null
	if obj == Game_Command.Obj_Enum.PLAYER:
		result = player
	elif obj == Game_Command.Obj_Enum.SYSTEM:
		result = system
	return result

func process_command(cmd:Game_Command) -> Actual_Command:
	var debug_cmd_info = [Game_Command.Obj_Enum.keys()[cmd.obj], 
			Game_Command.Cmd_Enum.keys()[cmd.cmd], 
			GQ.get_str(cmd.prop), cmd.value]
	prints(debug_cmd_info)
	
	# determine object
	var obj = _determine_object(cmd.obj)
	if obj == null:
		push_error(debug_cmd_info, " does not reference a correct object")
		return null
	
	var value = cmd.value
	var old_value = null
	if (cmd.cmd == Game_Command.Cmd_Enum.RNG_ADD
			or cmd.cmd == Game_Command.Cmd_Enum.RNG_SUB
			or cmd.cmd == Game_Command.Cmd_Enum.RNG_SET):
		var r_str:PackedStringArray = cmd.value.split(",")
		if r_str.size() < 2 or !r_str[0].is_valid_int() or !r_str[1].is_valid_int():
			push_error(debug_cmd_info, " does not reference a correct range")
			return null
		var rmin:int = r_str[0].to_int()
		var rmax:int = r_str[1].to_int()
		value = rng.randi_range(rmin, rmax)
		value = str(value)
	
	# determine operation
	if (cmd.cmd == Game_Command.Cmd_Enum.ADD 
			or cmd.cmd == Game_Command.Cmd_Enum.RNG_ADD):
		old_value = mod_prop(obj, cmd.prop, value)
	elif (cmd.cmd == Game_Command.Cmd_Enum.SUB 
			or cmd.cmd == Game_Command.Cmd_Enum.RNG_SUB):
		old_value = mod_prop(obj, cmd.prop, value, false)
	elif (cmd.cmd == Game_Command.Cmd_Enum.SET
			or cmd.cmd == Game_Command.Cmd_Enum.RNG_SET):
		old_value = set_prop(obj, cmd.prop, value)
	else:
		push_error(debug_cmd_info, " does not reference a correct command")
		return null
	return Actual_Command.build(cmd, value, old_value)

func check_condition(cond:Game_Condition) -> bool:
	var debug_cond_info = [Game_Command.Obj_Enum.keys()[cond.obj], 
			Game_Condition.Op_Enum.keys()[cond.cmd], 
			GQ.get_str(cond.prop), cond.value]
	prints(debug_cond_info)
	
	var obj = _determine_object(cond.obj)
	if obj == null:
		push_error(debug_cond_info, " does not reference a correct object")
		return false
	
	if cond.cmd == Game_Condition.Op_Enum.LESS:
		var v_str:String = get_prop(cond.obj, cond.prop)
		if v_str == null:
			v_str = "0"
		if !v_str.is_valid_int():
			push_error(debug_cond_info, " is trying to compare a non-integer value")
			return false
		var v:int = v_str.to_int()
		var c:int = cond.value.to_int()
		if v < c:
			return true
		return false
	elif cond.cmd == Game_Condition.Op_Enum.MORE:
		var v_str = get_prop(cond.obj, cond.prop)
		if v_str == null:
			v_str = "0"
		if !v_str.is_valid_int():
			push_error(debug_cond_info, " is trying to compare a non-integer value")
			return false
		var v:int = v_str.to_int()
		var c:int = cond.value.to_int()
		if v > c:
			return true
		return false
	elif cond.cmd == Game_Condition.Op_Enum.EQ:
		var v = get_prop(cond.obj, cond.prop)
		var c = cond.value
		if v == c:
			return true
		return false
	elif cond.cmd == Game_Condition.Op_Enum.RANGE:
		var r_str:PackedStringArray = cond.value.split(",")
		if r_str.size() < 2 or !r_str[0].is_valid_int() or !r_str[1].is_valid_int():
			push_error(debug_cond_info, " does not reference a correct range")
			return false
		var rmin:int = r_str[0].to_int()
		var rmax:int = r_str[1].to_int()
		
		var v_str:String = get_prop(cond.obj, cond.prop)
		if v_str == null:
			v_str = "0"
		if !v_str.is_valid_int():
			push_error(debug_cond_info, " is trying to compare a non-integer value")
			return false
		var v:int = v_str.to_int()
		
		if v >= rmin and v <= rmax:
			return true
		return false
	else:
		push_error(debug_cond_info, " does not reference a correct operand")
		return false

func onwards_from_result(next_action:Game_Action):
	# sort all postprocs in descending order
	var postprocs_sorted:Array = postprocs.values()
	postprocs_sorted.sort_custom(func(a, b): return a.priority > b.priority)
	
	# check all postprocs
	for v in postprocs_sorted:
		var postproc:Game_PostProc = v
		
		var all_conds_true:bool = true
		for cond in postproc.conds:
			if !World.check_condition(cond):
				all_conds_true = false
		if all_conds_true:
			# apply all silent ones immediately
			if postproc.silent:
				process_all_cmds(postproc.cmds)
			else:
				# once an aplicable non-silent is found, go to it
				var act_cmds:Array[Actual_Command] = process_all_cmds(postproc.cmds)
				var act_result:Actual_Result = Actual_Result.build(postproc.result, act_cmds, [])
				go_to_result(act_result)
				return
	# if no applicable non-silent is found, go to usual action
	go_to_action(next_action)

func option_to_result(option:Game_Option):
	print("Selected option: %s" % option.title)
	
	var all_challenge_success:bool = true
	var actual_ch:Array[Actual_Challenge] = []
	for ch in option.challenges:
		var r:int = rng.randi_range(1, 100)
		if r > ch.calc_challenge_chance():
			all_challenge_success = false
			actual_ch.append(Actual_Challenge.build(ch.prop, ch.check_success, ch.check_fail, false))
		else:
			actual_ch.append(Actual_Challenge.build(ch.prop, ch.check_success, ch.check_fail, true))
			
	var result:Game_Result = option.result_success if all_challenge_success else option.result_fail
	var act_cmds:Array[Actual_Command] = process_all_cmds(result.cmds)
	var act_result:Actual_Result = Actual_Result.build(result, act_cmds, actual_ch)
	go_to_result(act_result)

func process_all_cmds(cmds:Array[Game_Command]) -> Array[Actual_Command]:
	var result:Array[Actual_Command] = []
	for cmd in cmds:
		var actual_cmd:Actual_Command = process_command(cmd)
		if actual_cmd != null:
			result.append(actual_cmd)
	return result

func connect_gui(new_gui:Control) -> void:
	GUI = new_gui
	emit_signal("gui_connected")

func get_all_qualities_by_category(obj:Game_Command.Obj_Enum, 
									category:Game_Quality.Category_Enum):
	var result:Array = []
	var o:Dictionary = _determine_object(obj) 
	for key in o.keys():
		var quality:Game_Quality = quals.get(key)
		if quality.category == category:
			result.append(quality)
	return result

func go_to_action(action:Game_Action):
	is_cur_action = true
	cur_panel = action.id
	GUI.go_to_action(action)
	
func go_to_result(result:Actual_Result):
	is_cur_action = false
	cur_panel = result.id
	GUI.go_to_result(result)
