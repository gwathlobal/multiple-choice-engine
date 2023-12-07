extends Object

class_name Actual_Command

var icon:Texture
var obj:Game_Command.Obj_Enum
var cmd:Game_Command.Cmd_Enum
var prop:GQ.Nms
var value:String
var old_value:String

static func build(new_cmd:Game_Command, val:String, old_val:String) -> Actual_Command:
	var actual_cmd:Actual_Command = Actual_Command.new()
	actual_cmd.icon = new_cmd.icon
	actual_cmd.obj = new_cmd.obj
	actual_cmd.cmd = new_cmd.cmd
	actual_cmd.prop = new_cmd.prop
	actual_cmd.value = val
	actual_cmd.old_value = old_val
	return actual_cmd

func convert_to_dict() -> Dictionary:
	var result:Dictionary = {} 
	result["icon"] = icon.get_path()
	result["obj"] = Game_Command.Obj_Enum.keys()[obj]
	result["cmd"] = Game_Command.Cmd_Enum.keys()[cmd]
	result["prop"] = GQ.get_str(prop)
	result["value"] = value
	result["old_value"] = old_value
	return result

static func build_from_dict(dict:Dictionary) -> Actual_Command:
	var actual_cmd:Actual_Command = Actual_Command.new()
	actual_cmd.icon = load(dict["icon"])
	actual_cmd.obj = Game_Command.Obj_Enum.get(dict["obj"])
	actual_cmd.cmd = Game_Command.Cmd_Enum.get(dict["cmd"])
	actual_cmd.prop = GQ.get_from_str(dict["prop"])
	actual_cmd.value = dict["value"]
	actual_cmd.old_value = dict["old_value"]
	return actual_cmd
