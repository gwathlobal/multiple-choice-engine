extends VBoxContainer

@export var quality_label:RichTextLabel
@export var progress_bar:ProgressBar
@export var progress_label:Label

@export var obj:Game_Command.Obj_Enum
@export var quality:GQ.Nms

func _ready():
	World.quality_changed.connect(_on_changed_quality_value)
	World.gui_connected.connect(_on_gui_connected)

func _on_changed_quality_value():
	var placeholder:Dictionary = {
		"cur": World.get_prop(obj, quality),
		"max": World.quals.get(quality).max_value
	}
	progress_label.text = "{cur}/{max}".format(placeholder)
	progress_bar.value = placeholder.get("cur").to_int()
	progress_bar.max_value = placeholder.get("max")

func _on_gui_connected():
	World.GUI.options_dialog.locale_changed.connect(_on_locale_changed)
	_on_locale_changed()
	_on_changed_quality_value()

func _on_locale_changed():
	var qual:Game_Quality = World.quals.get(quality) 
	var placeholders:Dictionary = qual.get_general_quality_declination_tr()
	quality_label.text = tr("[center]{qual_pl_nom}[/center]").format(placeholders)
