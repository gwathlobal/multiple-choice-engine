extends GUI_Base_Window

class_name Confirm_Dialog

@export var confirm_label:Label
@export var ok_btn:Button
@export var cancel_btn:Button

var confirm_callable:Callable

func _ready():
	get_tree().get_root().connect("size_changed", on_resize)

	ok_btn.connect("pressed", ok_pressed)
	cancel_btn.connect("pressed", cancel_pressed)

	hide_window()
	call_deferred("on_resize")

func set_up(confirm_string:String, placeholders:Dictionary, confirm_func:Callable):
	confirm_label.text = tr(confirm_string).format(placeholders)
	confirm_callable = confirm_func
	
func ok_pressed():
	hide_window()
	confirm_callable.call()
	
func cancel_pressed():
	hide_window()
	
