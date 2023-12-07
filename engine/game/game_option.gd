extends Resource

class_name Game_Option

@export var img: Texture
@export_multiline var title: String
@export_multiline var text: String
@export var result_success: Game_Result
@export var result_fail: Game_Result
@export var conds: Array[Game_Condition]
@export var challenges: Array[Game_Challenge]
