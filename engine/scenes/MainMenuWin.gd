extends Control

@export var backround_panel:PanelContainer
@export var max_vbox:VBoxContainer
@export var game_title_box:MarginContainer
@export var game_title_label:RichTextLabel
@export var new_game_btn:Button
@export var load_game_btn:Button
@export var options_btn:Button
@export var exit_game_btn:Button
@export var options_dialog:Options_Dialog
@export var load_game_dialog:Load_Game_Dialog

var title_settings:Title_Settings = preload("res://default/settings/title_settings.tscn").instantiate() as Title_Settings

const MAIN_GAME_TITLE = "MAIN_GAME_TITLE"

func _ready():
	TranslationServer.set_locale('ru')
	
	get_tree().get_root().connect("size_changed", on_resize)
	
	new_game_btn.connect("pressed", new_game)
	
	load_game_btn.connect("pressed", load_game_dialog.show_window.bind(null, false))
	load_game_dialog.set_up(false, Preloader.game_scene)
	
	options_btn.connect("pressed", options_dialog.show_window.bind(null, false))
	
	exit_game_btn.connect("pressed", exit_game)
	
	options_dialog.locale_changed.connect(set_game_title)
	set_game_title()
	
	call_deferred("on_resize")

func on_resize(): 
	backround_panel.set_size(get_viewport_rect().size)
	max_vbox.set_size(get_viewport_rect().size)

func exit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func new_game():
	get_tree().change_scene_to_packed(Preloader.game_scene)
	Save_Load.new_game(World)

func set_game_title():
	if title_settings.show_title_text:
		game_title_label.text = "[center]" + tr(MAIN_GAME_TITLE) + "[/center]"
		game_title_label.show()
		game_title_box.show()
	else:
		game_title_label.hide()
		game_title_box.hide()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
