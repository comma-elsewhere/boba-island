class_name InventoryGrid extends GridContainer

signal return_item(item: Item)
signal item_taken(index: int)
signal item_placed(item: Item, index: int)

@export var inventory_item: PackedScene


func display(items: Array[Item]) -> void:
	for child in get_children():
		child.queue_free()
		
	for i in len(items):
		var new_slot = inventory_item.instantiate()
		add_child(new_slot)
		new_slot.index = i
		new_slot.return_item.connect(func(new_item: Item) -> void: return_item.emit(new_item))
		new_slot.item_taken.connect(func(index: int) -> void: item_taken.emit(index))
		new_slot.item_placed.connect(func(new_item: Item, index: int) -> void: item_placed.emit(new_item, index))
		new_slot.display(items[i])
