extends Resource

class_name Game_Condition

enum Op_Enum {LESS, MORE, EQ, RANGE}

enum Vis_Enum {GREYED, HIDDEN}

@export var img: Texture
@export var obj:Game_Command.Obj_Enum
@export var cmd:Op_Enum
@export var prop:GQ.Nms
@export var value:String
@export var visible:bool = true
@export var option_visible_on_fail:Vis_Enum

func get_hint(success:bool) -> String:
	var quality:Game_Quality = World.quals.get(prop)
	var hint_template:String = ""
	
	var placeholders:Dictionary = quality.get_general_quality_declination_tr()
	if (cmd == Game_Condition.Op_Enum.LESS
			or cmd == Game_Condition.Op_Enum.MORE
			or cmd == Game_Condition.Op_Enum.EQ):
		var val = value
		var cur_val = World.get_prop(obj, prop)
		if quality.type == Game_Quality.Type_Enum.ENUM:
			if quality.category == Game_Quality.Category_Enum.JOURNAL:
				val = tr(quality.get_journal_entry_value(value, Game_Quality.Journal_Entry_Enum.SHORT))
				cur_val = tr(quality.get_journal_entry_value(cur_val, Game_Quality.Journal_Entry_Enum.SHORT))
			else:
				val = tr(quality.get_enum_value(value))
				cur_val = tr(quality.get_enum_value(cur_val))
			if val == null:
				push_error([Game_Command.Obj_Enum.keys()[obj], 
							Game_Command.Cmd_Enum.keys()[cmd], 
							GQ.get_str(prop), value], " references a ENUM quality but does not have a correct ENUM value")
		placeholders["comp_value"] = val
		placeholders["cur_value"] = cur_val
		if cmd == Game_Condition.Op_Enum.LESS:
			if success:
				hint_template = quality.less_text_cond_succ
			else:
				hint_template = quality.less_text_cond_fail
		elif cmd == Game_Condition.Op_Enum.MORE:
			if success:
				hint_template = quality.more_text_cond_succ
			else:
				hint_template = quality.more_text_cond_fail
		elif cmd == Game_Condition.Op_Enum.EQ:
			if success:
				hint_template = quality.eq_text_cond_succ
			else:
				hint_template = quality.eq_text_cond_fail
				
	elif (cmd == Game_Condition.Op_Enum.RANGE):
		var r_str:PackedStringArray = value.split(",")
		if r_str.size() < 2 or !r_str[0].is_valid_int() or !r_str[1].is_valid_int():
			push_error([obj, cmd, prop, value], " does not reference a correct range")
			return ""
		var val_min = r_str[0]
		var val_max = r_str[1]
		var cur_val = World.get_prop(obj, prop)
		if quality.type == Game_Quality.Type_Enum.ENUM:
			if quality.category == Game_Quality.Category_Enum.JOURNAL:
				val_min = tr(quality.get_journal_entry_value(val_min, Game_Quality.Journal_Entry_Enum.SHORT))
				val_max = tr(quality.get_journal_entry_value(val_max, Game_Quality.Journal_Entry_Enum.SHORT))
				cur_val = tr(quality.get_journal_entry_value(cur_val, Game_Quality.Journal_Entry_Enum.SHORT))
			else:
				val_min = tr(quality.get_enum_value(val_min))
				val_max = tr(quality.get_enum_value(val_max))
				cur_val = tr(quality.get_enum_value(cur_val))
			if val_min == null or val_max == null:
				push_error([Game_Command.Obj_Enum.keys()[obj], 
							Game_Command.Cmd_Enum.keys()[cmd], 
							GQ.get_str(prop), value], " references a ENUM quality but does not have a correct ENUM value")
		placeholders["min_value"] = val_min
		placeholders["max_value"] = val_max
		placeholders["cur_value"] = cur_val
		
		if success:
			hint_template = quality.range_text_cond_succ
		else:
			hint_template = quality.range_text_cond_fail
		
	return tr(hint_template).format(placeholders)
