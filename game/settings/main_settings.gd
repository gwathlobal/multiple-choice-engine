extends Resource

class_name Main_Settings

enum Low_Panel_Button_State {
	AUTO,
	ENABLED,
	DISABLED
}

enum Available_Locales {
	EN,
	RU
}

static func get_locale_name(locale:Available_Locales) -> String:
	return Available_Locales.keys()[locale].to_lower()

@export var show_left_panel:bool = true
@export var show_stats:Low_Panel_Button_State
@export var show_inv:Low_Panel_Button_State
@export var show_journal:Low_Panel_Button_State
@export var initial_action:String
@export var initial_action_values:Array[Initial_Action_Value]
@export var default_locale:Available_Locales = Available_Locales.EN
