extends GUI_Base_Window

class_name Load_Game_Dialog

var btn_group:ButtonGroup
var btn_pressed:Control = null
var selected_filename:String = ""

var show_confirm:bool = true
var new_scene:PackedScene = null

@export var scroll_vbox_container:VBoxContainer
@export var load_game_btn:Button
@export var close_btn:Button
@export var confirm_dialog:Confirm_Dialog

@onready var saved_game_panel_prefab = preload("res://engine/gui/elements/save_game_panel/saved_game_panel.tscn")

const LOAD_GAME_CONFIRM_TEXT:String = "LOAD_GAME_CONFIRM_TEXT"

func _ready():
	get_tree().get_root().connect("size_changed", on_resize)
	
	close_btn.connect("pressed", hide_window)
	load_game_btn.connect("pressed", load_game)
	
	hide_window()
	call_deferred("on_resize")

func set_up(_show_confirm:bool, _new_scene:PackedScene):
	show_confirm = _show_confirm
	new_scene = _new_scene

func _on_visibility_changed():
	if not visible:
		return
	
	btn_group = ButtonGroup.new()
	
	for child in scroll_vbox_container.get_children():
		child.queue_free()
	
	var dir = Save_Load.get_files_at_save_dir()
	for filename in dir:
		var save_panel:Saved_Game_Panel = saved_game_panel_prefab.instantiate()
		scroll_vbox_container.add_child(save_panel)
		
		save_panel.set_up(filename, btn_group, self, confirm_dialog, 
							set_pressed, _on_visibility_changed)
	
	load_game_btn.disabled = true

func set_pressed(filename):
	selected_filename = filename
	load_game_btn.disabled = false

func load_game():
	var placeholders:Dictionary = {
		"filename": selected_filename
	}
	if show_confirm:
		confirm_dialog.set_up(LOAD_GAME_CONFIRM_TEXT, placeholders, load_game_confirm)
		confirm_dialog.show_window(self, false)
	else:
		load_game_confirm()

func load_game_confirm():
	if new_scene != null:
		get_tree().change_scene_to_packed(new_scene)
	Save_Load.load_game(selected_filename, World)
	hide_window()
	if parent != null:
		parent.hide_window()

