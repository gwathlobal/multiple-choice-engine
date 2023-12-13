extends Node

class_name GQ

enum Nms {
	SYS_BACKGROUND_IMG
}

static func get_str(val: Nms) -> String:
	return Nms.keys()[val]

static func get_from_str(val:String) -> Nms:
	return Nms.get(val)
