extends Control

@export var vbox:VBoxContainer
@export var action_panel:Action_Panel
@export var result_panel:Result_Panel
@export var menu_bar:GameMenuBar
@export var options_dialog:Options_Dialog
@export var inv_dialog:Inventory_Dialog
@export var journal_dialog:Journal_Dialog
@export var main_menu_dialog:Main_Menu_Dialog
@export var background_texture:TextureRect
@export var left_props_panel:MarginContainer

var main_settings:Main_Settings = preload("res://default/settings/main_settings.tscn").instantiate() as Main_Settings

func _ready():
	print("Start GUI")
	TranslationServer.set_locale('ru')
	
	var res0:Game_Action = World.actions.get(World.initial_action)
	go_to_action(res0)
	
	get_tree().get_root().connect("size_changed", on_resize)
	
	menu_bar.options_btn.connect("pressed", main_menu_dialog.show_window.bind(null, false))	
	menu_bar.inv_btn.connect("pressed", show_inventory)
	menu_bar.journal_btn.connect("pressed", journal_dialog.show_journal)
	
	World.connect_gui(self)
	
	if main_settings.show_left_panel:
		left_props_panel.show()
	else:
		left_props_panel.hide()
	
	menu_bar.show_inv()
	menu_bar.show_journal()
	menu_bar.show_stats()
	
	call_deferred("on_resize")
	print("End GUI")

func on_resize(): 
	vbox.set_size(get_viewport_rect().size)

func go_to_result(result:Actual_Result):
	action_panel.hide()
	result_panel.show()
	
	result_panel.set_result(result)

func go_to_action(action:Game_Action):
	action_panel.show()
	result_panel.hide()
	
	action_panel.set_action(action)
	
	background_texture.texture = action.background

func show_options():
	options_dialog.show_options()
	
func show_main_menu():
	main_menu_dialog.show_main_menu()
	
func show_inventory():
	inv_dialog.show_inventory()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
