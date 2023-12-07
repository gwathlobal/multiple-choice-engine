extends HBoxContainer

class_name GUI_Challenge

@export var icon:TextureRect
@export var label:RichTextLabel

func set_challenge(ch:Game_Challenge):
	var quality:Game_Quality = World.quals.get(ch.prop)
	icon.texture = quality.icon
	
	var placeholders:Dictionary = quality.get_general_quality_declination_tr()
	placeholders["chance"] = ch.calc_challenge_chance()
	label.text = tr(ch.description).format(placeholders)
	
