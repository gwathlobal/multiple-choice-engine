extends PanelContainer

class_name Saved_Game_Panel

@export var saved_game:Button
@export var delete_btn:TextureButton

var filename:String
var confirm_dialog:Confirm_Dialog
var parent_win:GUI_Base_Window
var post_select_callback:Callable
var post_delete_callback:Callable

const DELETE_GAME_CONFIRM_TEXT = "DELETE_GAME_CONFIRM_TEXT"

func set_up(save_game_name:String, btn_group:ButtonGroup, 
			new_parent_win: GUI_Base_Window, new_confirm_dialog:Confirm_Dialog,
			new_post_select_callback:Callable, new_post_delete_callback:Callable):
	saved_game.button_group = btn_group
	if btn_group == null:
		saved_game.toggle_mode = false
	
	saved_game.text = save_game_name
	filename = save_game_name
	
	confirm_dialog = new_confirm_dialog
	parent_win = new_parent_win
	post_select_callback = new_post_select_callback
	post_delete_callback = new_post_delete_callback

func _on_delete_button_pressed():
	var placeholders:Dictionary = {
		"filename": filename
	}
	confirm_dialog.set_up(DELETE_GAME_CONFIRM_TEXT, placeholders, delete_game_confirm)
	confirm_dialog.show_window(parent_win, false)

func delete_game_confirm():
	DirAccess.remove_absolute("user://saves/"+filename)
	post_delete_callback.call()

func _on_button_pressed():
	post_select_callback.call(filename)
