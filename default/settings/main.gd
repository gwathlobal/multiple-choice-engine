extends Node

class_name Main_Settings

enum Low_Panel_Button_State {
	AUTO,
	ENABLED,
	DISABLED
}

@export var show_left_panel:bool = true
@export var show_stats:Low_Panel_Button_State
@export var show_inv:Low_Panel_Button_State
@export var show_journal:Low_Panel_Button_State