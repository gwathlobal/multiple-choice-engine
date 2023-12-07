extends Resource

class_name Game_Command

enum Cmd_Enum {SET, ADD, SUB, RNG_SET, RNG_ADD, RNG_SUB}
enum Obj_Enum {SYSTEM, PLAYER} 

@export var icon:Texture
@export var obj:Obj_Enum
@export var cmd:Cmd_Enum
@export var prop:GQ.Nms
@export var value:String
