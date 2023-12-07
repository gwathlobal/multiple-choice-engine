extends Node

class_name GQ

#var Nms = {
#	"PLAYER_ACTION_POINTS": "PLAYER_ACTION_POINTS",
#	"PLAYER_QUEST": "PLAYER_QUEST",
#	"PLAYER_ITEM": "PLAYER_ITEM",
#	"PLAYER_WOUND": "PLAYER_WOUND",
#	"PLAYER_RANDOM_VALUE": "PLAYER_RANDOM_VALUE",
#	"PLAYER_NAME": "PLAYER_NAME",
#	"PLAYER_SKILL": "PLAYER_SKILL"
#}

enum Nms {
	SYS_BACKGROUND_IMG,
	PLAYER_ACTION_POINTS,
	PLAYER_QUEST,
	PLAYER_ITEM,
	PLAYER_WOUND,
	PLAYER_RANDOM_VALUE,
	PLAYER_NAME,
	PLAYER_SKILL
}

static func get_str(val: Nms) -> String:
	return Nms.keys()[val]

static func get_from_str(val:String) -> Nms:
	return Nms.get(val)
