class_name InventoryStorage extends Inventory

func add_item(item: Item) -> bool:
	var new_item = item.duplicate()
	if !_contents.is_empty():
		if _stack(new_item):
			return true
	else:
		if _add_to_empty(new_item):
			return true
	return false
