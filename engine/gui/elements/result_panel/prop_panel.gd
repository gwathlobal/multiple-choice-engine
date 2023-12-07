extends HBoxContainer

class_name GUI_Prop

@export var icon:TextureRect
@export var text:RichTextLabel
@export var progress_container:HBoxContainer
@export var progress_bar:ProgressBar
@export var cur_value_label:Label
@export var next_value_label:Label

func set_prop(img:Texture, txt:String, cur_value:int = 0, 
				cur_prog:int = 0, max_prog:int = 0):
	icon.texture = img
	text.text = "[i]%s[/i]" % txt
	if max_prog == 0:
		progress_container.hide()
	else:
		progress_bar.max_value = max_prog
		progress_bar.value = cur_prog
		cur_value_label.text = str(cur_value)
		next_value_label.text = str(cur_value + 1)
		progress_container.show()
