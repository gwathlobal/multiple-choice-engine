extends Panel

class_name Inventory_Dialog

@export var close_btn:Button
@export var inv_container:HFlowContainer
 
var item_prefab = preload("res://engine/gui/elements/item/gui_item.tscn")

func _ready():
	get_tree().get_root().connect("size_changed", on_resize)
	
	close_btn.connect("pressed", hide_inventory)
	
	hide_inventory()
	call_deferred("on_resize")

func on_resize(): 
	set_size(get_viewport_rect().size)

func show_inventory():
	for child in inv_container.get_children():
		child.queue_free()
	var items:Array = World.get_all_qualities_by_category(Game_Command.Obj_Enum.PLAYER, Game_Quality.Category_Enum.ITEM)
	for item in items:
		var value:int = World.get_prop(Game_Command.Obj_Enum.PLAYER, item.id).to_int()
		if value <= 0:
			continue
		var gui_item:GUI_Item = item_prefab.instantiate()
		inv_container.add_child(gui_item)
		gui_item.set_item(item, str(value))
	show()

func hide_inventory():
	hide()
