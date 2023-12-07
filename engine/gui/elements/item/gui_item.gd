extends Button

class_name GUI_Item

@export var icon_btn:Button
@export var count_label:Label

var tooltip_prefab = preload("res://engine/gui/Tooltip.tscn")

func set_item(quality:Game_Quality, count: String) -> void:
	icon_btn.set_button_icon(quality.icon)
	count_label.text = count
	var placeholders:Dictionary = quality.get_general_quality_declination_tr()
	placeholders["count"] = count
	placeholders["descr"] = tr(quality.get_description())
	icon_btn.tooltip_text = "[b]{qual_sg_nom}[/b] {count}\n{descr}".format(placeholders)
	flat = true

func _make_custom_tooltip(txt:String) -> Object:
	# This exists, and is a Control node, with a panel-container and label inside of it
	var tooltip:RichTextLabel = tooltip_prefab.instantiate()
	tooltip.text = txt
	var _theme : Theme = self.theme
	var label_font : Font
	if _theme:
		label_font = _theme.get_font("font", "RichTextLabel").duplicate()
	else:
		label_font = get("custom_fonts/normal_font").duplicate()
	var split_strs = txt.split("\n")
	var str_size = Vector2(0,0)
	for strng in split_strs:
		var cur_size = label_font.get_string_size(strng)
		if cur_size.x > str_size.x:
			str_size = cur_size
	if str_size.x < tooltip.custom_minimum_size.x:
		tooltip.custom_minimum_size = str_size 
	return tooltip
