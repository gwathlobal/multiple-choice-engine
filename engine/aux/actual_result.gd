extends Object

class_name Actual_Result

var id:String
var img: Texture 
var title: String
var text: String
var go_to:String
var game_over:bool
var cmds:Array[Actual_Command]
var challenge_results:Array[Actual_Challenge]

static func build(result:Game_Result, act_cmds:Array[Actual_Command],
					ch_results:Array[Actual_Challenge]) -> Actual_Result:
	var actual_result:Actual_Result = Actual_Result.new()
	actual_result.id = result.id
	actual_result.img = result.img
	actual_result.title = result.title
	actual_result.text = result.text
	actual_result.go_to = result.go_to
	actual_result.game_over = result.game_over
	actual_result.cmds = act_cmds
	actual_result.challenge_results = ch_results
	return actual_result

func convert_to_dict() -> Dictionary:
	var result:Dictionary = {} 
	result["id"] = id
	
	result["cmds"] = []
	for cmd in cmds:
		result["cmds"].append(cmd.convert_to_dict())
	
	result["challenge_results"] = []
	for ch in challenge_results:
		result["challenge_results"].append(ch.convert_to_dict())
	return result

static func build_from_dict(dict:Dictionary) -> Actual_Result:
	var act_cmds:Array[Actual_Command] = []
	for cmd in dict["cmds"]:
		act_cmds.append(Actual_Command.build_from_dict(cmd))
		
	var act_chs:Array[Actual_Challenge] = []
	for ch in dict["challenge_results"]:
		act_chs.append(Actual_Challenge.build_from_dict(ch))
	
	return build(World.results[dict["id"]], act_cmds, act_chs)
