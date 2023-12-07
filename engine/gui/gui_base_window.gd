extends Control

class_name GUI_Base_Window

var parent:GUI_Base_Window
var hide_parent:bool = false

func show_window(_parent:GUI_Base_Window, new_hide_parent:bool) -> void:
	parent = _parent
	if parent != null and new_hide_parent:
		parent.hide()
		hide_parent = new_hide_parent
	show()
	
func hide_window() -> void:
	hide()
	if parent != null:
		parent.show_window(parent.parent, hide_parent)

func hide_window_forced() -> void:
	hide()

func on_resize(): 
	set_size(get_viewport_rect().size)
