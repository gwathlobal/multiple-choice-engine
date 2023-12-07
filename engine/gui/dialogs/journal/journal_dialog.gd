extends Panel

class_name Journal_Dialog

@export var close_btn:Button
@export var journal_container:VBoxContainer
 
var journal_prefab = preload("res://engine/gui/elements/journal_entry/gui_journal_entry.tscn")

func _ready():
	get_tree().get_root().connect("size_changed", on_resize)
	
	close_btn.connect("pressed", hide_journal)
	
	hide_journal()
	call_deferred("on_resize")

func on_resize(): 
	set_size(get_viewport_rect().size)

func show_journal():
	for child in journal_container.get_children():
		child.queue_free()
	var entries:Array = World.get_all_qualities_by_category(Game_Command.Obj_Enum.PLAYER, Game_Quality.Category_Enum.JOURNAL)
	for entry in entries:
		var strng:String = entry.get_journal_entry_value(World.get_prop(Game_Command.Obj_Enum.PLAYER, entry.id), Game_Quality.Journal_Entry_Enum.LONG)
		if strng == null:
			continue
		var gui_journal:GUI_Journal_Entry = journal_prefab.instantiate()
		journal_container.add_child(gui_journal)
		gui_journal.set_journal(entry, strng)
	show()

func hide_journal():
	hide()
