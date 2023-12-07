extends Resource

class_name Game_Challenge

@export var obj:Game_Command.Obj_Enum
@export var prop:GQ.Nms
@export var chance100:int
@export_multiline var description:String
@export_multiline var check_success:String
@export_multiline var check_fail:String

func calc_challenge_chance() -> int:
	var quality:Game_Quality = World.quals.get(prop)

	if (quality.type != Game_Quality.Type_Enum.INT 
			and quality.type != Game_Quality.Type_Enum.PROGRESS):
		push_error(GQ.Nms.keys()[quality.id], " is not a INT or PROGRESS quality, cannot calc challenge chance")
		return 0

	var raw_value:String = World.get_prop(obj, prop)
	var value:int = raw_value.to_int()
	if quality.type == Game_Quality.Type_Enum.PROGRESS:
		value = quality.calc_progress_values(value)[0]
	
	if value >= chance100:
		return 100
	
	@warning_ignore("integer_division")
	return roundi((100 * value) / chance100)
