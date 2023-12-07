extends HBoxContainer

class_name GameMenuBar

@onready var char_btn:TextureButton = $CharacterButton
@onready var inv_btn:TextureButton = $InventoryButton
@onready var journal_btn:TextureButton = $JournalButton
@onready var options_btn:TextureButton = $OptionsButton

var main_settings:Main_Settings = preload("res://default/settings/main_settings.tscn").instantiate() as Main_Settings

func show_stats():
	match main_settings.show_stats:
		Main_Settings.Low_Panel_Button_State.DISABLED:
			char_btn.hide()
		Main_Settings.Low_Panel_Button_State.AUTO:
			pass
		_:
			char_btn.show()

func show_inv():
	match main_settings.show_inv:
		Main_Settings.Low_Panel_Button_State.DISABLED:
			inv_btn.hide()
		Main_Settings.Low_Panel_Button_State.AUTO:
			pass
		_:
			inv_btn.show()

func show_journal():
	match main_settings.show_journal:
		Main_Settings.Low_Panel_Button_State.DISABLED:
			journal_btn.hide()
		Main_Settings.Low_Panel_Button_State.AUTO:
			pass
		_:
			journal_btn.show()
			
