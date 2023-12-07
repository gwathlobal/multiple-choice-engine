extends TextureRect

class_name GUI_Cond

var tooltip_prefab = preload("res://engine/gui/Tooltip.tscn")

func set_cond(new_cond:Game_Condition):
	var success = World.check_condition(new_cond)
	texture = new_cond.img
	tooltip_text = new_cond.get_hint(success)
	
	if !success:
		self_modulate = Color(0.35, 0.35, 0.35, 1)
	else:
		self_modulate = Color(1, 1, 1, 1)

func _make_custom_tooltip(text:String) -> Object:
	# This exists, and is a Control node, with a panel-container and label inside of it
	var tooltip:RichTextLabel = tooltip_prefab.instantiate()
	tooltip.text = text
	var _theme : Theme = self.theme
	var label_font : Font
	if _theme:
		label_font = _theme.get_font("font", "RichTextLabel").duplicate()
	else:
		label_font = get("custom_fonts/normal_font").duplicate()
	var str_size = label_font.get_string_size(text)
	if str_size.x < tooltip.custom_minimum_size.x:
		tooltip.custom_minimum_size = str_size 
	return tooltip
	
