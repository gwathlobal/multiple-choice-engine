extends VBoxContainer

class_name Action_Panel

@onready var icon:TextureRect = $HBoxContainer/Icon
@onready var title:RichTextLabel = $HBoxContainer/VBoxContainer/Title
@onready var text:RichTextLabel = $HBoxContainer/VBoxContainer/Text
@onready var options_container:VBoxContainer = $ScrollContainer/VBoxContainer2
@export var return_btn:Button

var option_prefab = preload("res://engine/gui/elements/action_panel/option_panel.tscn")

var action:Game_Action

func _ready():
	World.gui_connected.connect(_on_gui_connected)

func set_action(new_action:Game_Action):
	action = new_action
	
	icon.texture = action.img
	title.text = "[b]" +  tr(action.title) + "[/b]"
	text.text = tr(action.text)
	
	if action.return_to == null or action.return_to == "":
		return_btn.hide()
	else:
		return_btn.show()
	
	for option in options_container.get_children():
		option.queue_free()
	
	for template in action.options:
		var all_conds_true:bool = true
		var hide_on_cond_fail:bool = false
		for cond in template.conds:
			if !World.check_condition(cond):
				if cond.option_visible_on_fail == Game_Condition.Vis_Enum.HIDDEN:
					hide_on_cond_fail = true
				all_conds_true = false
		var greyed:bool = false
		if !all_conds_true:
			if hide_on_cond_fail:
				continue
			else:
				greyed = true
			
		var option:GUI_Option = option_prefab.instantiate()
		options_container.add_child(option)
		option.set_option(template, greyed)

func reshow_action():
	if action != null:
		set_action(action)

func _on_gui_connected():
	World.GUI.options_dialog.locale_changed.connect(reshow_action)
