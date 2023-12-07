extends Object

class_name Actual_Challenge

var prop_name:GQ.Nms
var check_success:String
var check_fail:String
var success:bool

static func build(new_prop_name:GQ.Nms, new_check_success:String,
					new_check_fail:String, new_success:bool) -> Actual_Challenge:
	var actual_ch:Actual_Challenge = Actual_Challenge.new()
	actual_ch.success = new_success
	actual_ch.prop_name = new_prop_name
	actual_ch.check_success = new_check_success
	actual_ch.check_fail = new_check_fail
	return actual_ch

func convert_to_dict() -> Dictionary:
	var result:Dictionary = {}
	result["prop_name"] = GQ.get_str(prop_name)
	result["check_success"] = check_success
	result["check_fail"] = check_fail
	result["success"] = success
	return result

static func build_from_dict(dict:Dictionary) -> Actual_Challenge:
	var actual_ch:Actual_Challenge = Actual_Challenge.new()
	actual_ch.prop_name = GQ.get_from_str(dict["prop_name"])
	actual_ch.check_success = dict["check_success"]
	actual_ch.check_fail = dict["check_fail"]
	actual_ch.success = dict["success"]
	return actual_ch
