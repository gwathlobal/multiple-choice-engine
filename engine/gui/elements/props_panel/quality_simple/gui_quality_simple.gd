extends HBoxContainer

class_name GUI_Quality_Simple

@export var icon:TextureRect
@export var quality_label:RichTextLabel
@export var value_label:Label
@export var progress_bar:ProgressBar

@export var obj:Game_Command.Obj_Enum
@export var quality:GQ.Nms
@export var label_txt:String

var qual:Game_Quality

func _ready():
	World.quality_changed.connect(_on_changed_quality_value)
	World.gui_connected.connect(_on_gui_connected)
	quality_label.text = label_txt
	qual = World.quals.get(quality) 
	if qual.type == Game_Quality.Type_Enum.PROGRESS:
		progress_bar.show()
	else:
		progress_bar.hide()

func _on_changed_quality_value():
	value_label.text = World.get_prop(obj, quality)
	if qual.type == Game_Quality.Type_Enum.PROGRESS:
		var value:int = value_label.text.to_int()
		var progress = qual.calc_progress_values(value)
		value_label.text = str(progress[0])
		progress_bar.value = progress[1]
		progress_bar.max_value = progress[2]

func _on_gui_connected():
	World.GUI.options_dialog.locale_changed.connect(_on_locale_changed)
	_on_locale_changed()
	_on_changed_quality_value()

func _on_locale_changed():
	var placeholders:Dictionary = qual.get_general_quality_declination_tr()
	quality_label.text = tr(label_txt).format(placeholders)
	icon.texture = qual.icon
