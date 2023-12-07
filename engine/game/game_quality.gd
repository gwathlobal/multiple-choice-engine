extends Resource

class_name Game_Quality

enum Type_Enum {INT, ENUM, STRING, PROGRESS}
enum Category_Enum {SYSTEM, MECHANICS, JOURNAL, ITEM, SKILL}
enum Journal_Entry_Enum {SHORT, LONG, TRANSITION}

@export var id:GQ.Nms
@export var icon:Texture2D
@export var type:Type_Enum
@export var category:Category_Enum
@export var values:Dictionary
@export var i18n_name:String
@export var min_value:int = 0
@export var max_value:int = 1_000_000
@export var progress_mult:int = 1

@export_multiline var set_text_result:String
@export_multiline var add_text_result:String
@export_multiline var sub_text_result:String

@export_multiline var prog_mod_real_value:String 

@export_multiline var less_text_cond_succ:String
@export_multiline var less_text_cond_fail:String
@export_multiline var more_text_cond_succ:String
@export_multiline var more_text_cond_fail:String
@export_multiline var eq_text_cond_succ:String
@export_multiline var eq_text_cond_fail:String
@export_multiline var range_text_cond_succ:String
@export_multiline var range_text_cond_fail:String

const JOURNAL_SHORT:String = "short"
const JOURNAL_LONG:String = "long"
const JOURNAL_TRANSITION:String = "trans"

func get_quality_declination_tr() -> Dictionary:
	var result:Dictionary = {}
	for decl in World.avail_declinations:
		var qual_decl:String = i18n_name + "_" + decl
		result[qual_decl] = tr(qual_decl) 
	return result

func get_general_quality_declination_tr() -> Dictionary:
	var result:Dictionary = {}
	for decl in World.avail_declinations:
		var qual_decl:String = i18n_name + "_" + decl
		var gen_decl:String = "qual_" + decl
		result[gen_decl] = tr(qual_decl) 
	return result

func get_description() -> String:
	return i18n_name + "_description"

func get_enum_value(i:String):
	if values == null:
		return null
	return values.get(i)

func get_journal_entry_value(i:String, entry_type:Journal_Entry_Enum):
	if values == null:
		return null
	if entry_type == Journal_Entry_Enum.SHORT:
		return values.get(i).get(JOURNAL_SHORT)
	elif entry_type == Journal_Entry_Enum.LONG:
		return values.get(i).get(JOURNAL_LONG)
	elif entry_type == Journal_Entry_Enum.TRANSITION:
		return values.get(i).get(JOURNAL_TRANSITION)
	else:
		push_error("Quality ", id, " is not able to process journal entry", entry_type)
	return null

func calc_progress_values(value:int) -> Array[int]:
	if type != Type_Enum.PROGRESS:
		return []
	var real_value:int = 0
	var cur_progress:int = 0
	var max_progress:int = 1
	while value >= 0:
		value -= max_progress
		if value >= 0:
			if max_progress == 1:
				max_progress += (progress_mult - 1)
			else:
				max_progress += progress_mult
			real_value += 1
			cur_progress = value
	print(GQ.Nms.keys()[id], [real_value, cur_progress, max_progress])
	return [real_value, cur_progress, max_progress]
