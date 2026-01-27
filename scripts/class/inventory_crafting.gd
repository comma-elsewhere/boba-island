class_name InventoryCraft extends Inventory

func add_item(item: Item) -> bool:
	if item == null:
		return false
	else:
		_contents.append(item)
		print(item.name)
		print(item.quality)
		return true
