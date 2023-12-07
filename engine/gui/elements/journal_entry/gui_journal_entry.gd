extends HBoxContainer

class_name GUI_Journal_Entry

@export var icon:TextureRect
@export var entry_label:RichTextLabel

func set_journal(quality:Game_Quality, value: String) -> void:
	icon.texture = quality.icon
	entry_label.text = tr(value)
