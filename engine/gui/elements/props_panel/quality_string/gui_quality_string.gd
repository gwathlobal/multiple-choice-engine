extends Label

@export var quality_label:Label

@export var obj:Game_Command.Obj_Enum
@export var quality:GQ.Nms
@export var translatable:bool

func _ready():
	World.quality_changed.connect(_on_changed_quality_value)
	World.gui_connected.connect(_on_gui_connected)

func _on_changed_quality_value():
	quality_label.text = World.get_prop(obj, quality)

func _on_gui_connected():
	World.GUI.options_dialog.locale_changed.connect(_on_locale_changed)
	_on_locale_changed()
	_on_changed_quality_value()

func _on_locale_changed():
	_on_changed_quality_value()
