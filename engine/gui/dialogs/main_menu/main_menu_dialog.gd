extends GUI_Base_Window

class_name Main_Menu_Dialog

@export var close_btn:Button
@export var settings_btn:Button
@export var save_game_btn:Button
@export var load_game_btn:Button
@export var exit_to_menu_btn:Button
@export var options_dialog:Options_Dialog
@export var load_game_dialog:Load_Game_Dialog
@export var save_game_dialog:Save_Game_Dialog
@export var confirm_dialog:Confirm_Dialog

const EXIT_TO_MAIN_MENU_CONFIRM_TEXT:String = "EXIT_TO_MAIN_MENU_CONFIRM_TEXT"

func _ready():
	get_tree().get_root().connect("size_changed", on_resize)
	
	close_btn.connect("pressed", hide_window)
	settings_btn.connect("pressed", options_dialog.show_window.bind(self, true))
	save_game_btn.connect("pressed", save_game_dialog.show_window.bind(self, true))
	load_game_btn.connect("pressed", load_game_dialog.show_window.bind(self, true))
	exit_to_menu_btn.connect("pressed", exit_to_main_menu)
	
	hide_window()
	call_deferred("on_resize")

func exit_to_main_menu():
	confirm_dialog.set_up(EXIT_TO_MAIN_MENU_CONFIRM_TEXT, {}, exit_to_main_menu_confirm)
	confirm_dialog.show_window(self, false)
	
func exit_to_main_menu_confirm():
	get_tree().change_scene_to_packed(Preloader.menu_scene)
	hide_window()
	if parent != null:
		parent.hide_window()
