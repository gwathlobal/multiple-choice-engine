extends GUI_Base_Window

class_name Options_Dialog

@export var close_btn:Button
@export var lang_dropdown:OptionButton

signal locale_changed

const map_id_to_locale:Dictionary = {
	0: "en",
	1: "ru"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", on_resize)
	
	close_btn.connect("pressed", hide_window)
	lang_dropdown.connect("item_selected", item_selected)
	
	hide_window()
	lang_dropdown.select(1)
	call_deferred("on_resize")

func on_resize(): 
	set_size(get_viewport_rect().size)

func item_selected(index: int):
	TranslationServer.set_locale(map_id_to_locale.get(index, 0))
	emit_signal("locale_changed")
