extends GUI_Base_Window

class_name Save_Game_Dialog

@export var scroll_vbox_container:VBoxContainer
@export var save_game_name_input:LineEdit
@export var save_game_btn:Button
@export var close_btn:Button
@export var confirm_dialog:Confirm_Dialog

@onready var saved_game_panel_prefab = preload("res://engine/gui/elements/save_game_panel/saved_game_panel.tscn")

const SAVE_GAME_OVERWRITE_CONFIRM_TEXT:String = "SAVE_GAME_OVERWRITE_CONFIRM_TEXT"

func _ready():
	get_tree().get_root().connect("size_changed", on_resize)
	
	close_btn.connect("pressed", hide_window)
	save_game_btn.connect("pressed", save_game)
	
	hide_window()
	call_deferred("on_resize")

func _on_visibility_changed():
	if not visible:
		return
	
	for child in scroll_vbox_container.get_children():
		child.queue_free()
	
	var dir = Save_Load.get_files_at_save_dir()
	for filename in dir:
		var save_panel:Saved_Game_Panel = saved_game_panel_prefab.instantiate()
		scroll_vbox_container.add_child(save_panel)

		save_panel.set_up(filename, null, self, confirm_dialog, 
							set_pressed, _on_visibility_changed)
	
	save_game_btn.disabled = true

func set_pressed(filename):
	save_game_name_input.text = filename
	_on_save_game_name_edit_text_changed(save_game_name_input.text)

func save_game():
	var overwrites_file:bool = false
	var dir = Save_Load.get_files_at_save_dir()
	for filename in dir:
		if filename == save_game_name_input.text:
			overwrites_file = true

	if overwrites_file:
		var placeholders:Dictionary = {
			"filename": save_game_name_input.text
		}
		confirm_dialog.set_up(SAVE_GAME_OVERWRITE_CONFIRM_TEXT, placeholders, save_game_confirm)
		confirm_dialog.show_window(self, false)
	else:
		save_game_confirm()

func save_game_confirm():
	Save_Load.save_game(save_game_name_input.text, World)
	hide_window()
	parent.hide_window()

func _on_save_game_name_edit_text_changed(new_text:String):
	if new_text != null and new_text.length() > 0:
		save_game_btn.disabled = false
	else:
		save_game_btn.disabled = true
