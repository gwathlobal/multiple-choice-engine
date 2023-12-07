extends PanelContainer

class_name GUI_Option

@onready var icon = $HBoxContainer/Icon
@onready var title = $HBoxContainer/VBoxContainer/Title
@onready var text = $HBoxContainer/VBoxContainer/Text
@onready var button = $HBoxContainer/VBoxContainer/HBoxContainer/Button
@onready var cond_container = $HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer
@export var challenge_container:VBoxContainer
@export var challenge_container_proper:VBoxContainer

var option:Game_Option

var cond_prefab = preload("res://engine/gui/elements/action_panel/cond_icon.tscn")
var challenge_prefab = preload("res://engine/gui/elements/action_panel/challenge_panel.tscn")

func set_option(new_option:Game_Option, greyed:bool = false):
	option = new_option
	
	icon.texture = option.img
	title.text = "[b]" + tr(option.title) + "[/b]"
	text.text = tr(option.text)
	
	if greyed:
		self_modulate = Color(0.35, 0.35, 0.35, 1)
		button.self_modulate = Color(0.5, 0.5, 0.5, 1)
		button.disabled = true
	else:
		self_modulate = Color(1, 1, 1, 1)
		button.self_modulate = Color(1, 1, 1, 1)
		button.disabled = false
	
	for child in cond_container.get_children():
		child.queue_free()
	
	for cond in new_option.conds:
		var gui_cond:GUI_Cond = cond_prefab.instantiate()
		cond_container.add_child(gui_cond)
		gui_cond.set_cond(cond)
		
	if new_option.challenges != null and new_option.challenges.size() > 0:
		challenge_container.show()
	else:
		challenge_container.hide()
	
	for child in challenge_container_proper.get_children():
		child.queue_free()
	
	for challenge in new_option.challenges:
		var gui_ch:GUI_Challenge = challenge_prefab.instantiate()
		challenge_container_proper.add_child(gui_ch)
		gui_ch.set_challenge(challenge)

func _on_button_pressed():
	World.option_to_result(option)
