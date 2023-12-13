extends VBoxContainer

class_name Result_Panel

@export var button_onwards:Button
@export var button_gameover:Button

@onready var icon:TextureRect = $HBoxContainer/Icon
@onready var title:RichTextLabel = $HBoxContainer/VBoxContainer/Title
@onready var text:RichTextLabel = $HBoxContainer/VBoxContainer/Text
@onready var prop_container = $ScrollContainer/PanelContainer/VBoxContainer
@onready var panel_container = $ScrollContainer/PanelContainer

@onready var prop_prefab = preload("res://engine/gui/elements/result_panel/prop_panel.tscn")

var result:Actual_Result

func _ready():
	World.gui_connected.connect(_on_gui_connected)

func set_result(new_result:Actual_Result):
	result = new_result
	
	icon.texture = result.img
	title.text = "[b]" + tr(result.title) + "[/b]"
	text.text = tr(result.text)	
	
	if result.go_to != null and result.go_to != "":
		button_onwards.show()
	else:
		button_onwards.hide()
	
	if result.game_over:
		button_onwards.hide()
		button_gameover.show()
	else:
		button_gameover.hide()
	
	for prop in prop_container.get_children():
		prop_container.remove_child(prop)
		prop.queue_free()
		
	
	for ch in result.challenge_results:
		var prop:GUI_Prop = prop_prefab.instantiate()
		prop_container.add_child(prop)
		
		var quality:Game_Quality = World.quals.get(ch.prop_name)
		var placeholders:Dictionary = quality.get_general_quality_declination_tr()
		var strng
		if ch.success:
			strng = tr(ch.check_success).format(placeholders)
		else:
			strng = tr(ch.check_fail).format(placeholders)
		
		prop.set_prop(quality.icon, strng, 0, 0, 0)
	
	for cmd in result.cmds:
		var prop:GUI_Prop = prop_prefab.instantiate()
		prop_container.add_child(prop)
		
		var quality:Game_Quality = World.quals.get(cmd.prop)
		var strng = "ERROR"
		var placeholders:Dictionary = quality.get_general_quality_declination_tr()
		var max_prog = 0
		var cur_prog = 0
		var cur_value = 0
		if quality.type != Game_Quality.Type_Enum.PROGRESS:
			placeholders["cur_value"] = World.get_prop(cmd.obj, cmd.prop)
		else:
			var value:int = World.get_prop(cmd.obj, cmd.prop).to_int()
			var old_value:int = cmd.old_value.to_int()
			var progress:Array[int] = quality.calc_progress_values(value)
			cur_value = progress[0]
			cur_prog = progress[1]
			max_prog = progress[2]
			var old_progress:Array[int] = quality.calc_progress_values(old_value)
			old_value = old_progress[0]
			placeholders["cur_value"] = str(cur_value)
			placeholders["mod_real_value"] = tr(quality.prog_mod_real_value).format(placeholders) if cur_value != old_value else ""
		placeholders["mod_value"] = cmd.value.to_int()
		
		if quality.type == Game_Quality.Type_Enum.ENUM:
			var enum_str:String = tr(quality.get_enum_value(World.get_prop(cmd.obj, cmd.prop), Game_Quality.Entry_Type_Enum.TRANSITION))
			placeholders["cur_value"] = enum_str
			if  enum_str == null:
				push_error([Game_Command.Obj_Enum.keys()[cmd.obj], 
							Game_Command.Cmd_Enum.keys()[cmd.cmd], 
							GQ.get_str(cmd.prop), cmd.value], " references a ENUM quality but does not have a correct ENUM value")
		
		if cmd.cmd == Game_Command.Cmd_Enum.SET:
			strng = tr(quality.set_text_result).format(placeholders)
		elif cmd.cmd == Game_Command.Cmd_Enum.ADD:
			strng = tr(quality.add_text_result).format(placeholders)
		elif cmd.cmd == Game_Command.Cmd_Enum.SUB:
			strng = tr(quality.sub_text_result).format(placeholders)
		
		prop.set_prop(cmd.icon, strng, cur_value, cur_prog, max_prog)
	
	if prop_container.get_child_count() > 0:
		panel_container.show()
	else:
		panel_container.hide()

func reshow_result():
	if result != null:
		set_result(result)

func _on_button_onwards_pressed():
	var go_to_action:Game_Action = World.actions.get(result.go_to)
	World.onwards_from_result(go_to_action)

func _on_button_gameover_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _on_gui_connected():
	World.GUI.options_dialog.locale_changed.connect(reshow_result)
