class_name Inventory

var _contents: Array[Item] = []
var _size: int

func init_with_empty(size: int) -> void:
	_size = size
	_contents.resize(size)
	
func remove_item(item: Item) -> void:
	_contents.erase(item)
	
func get_items() -> Array[Item]:
	return _contents
	
func clear_all() -> void:
	_contents.clear()
	_contents = []
	
func has_all(items: Array[Item]) -> bool:
	var needed: Array[String] = []
	var available: Array[String] = []
	
	for i in _contents:
		available.append(i.name)
		
	for i in items:
		needed.append(i.name)
		
	for item_available in available:
		needed.erase(item_available)
		
	print(available)
	print(needed)
		
	return needed.is_empty()
	
	
func _stack(new_item: Item) -> bool:
	for item in _contents:
		if item == null:
			pass
		else:
			if item.name == new_item.name:
				var amount_sum = item.amount + new_item.amount
				if amount_sum > item.stack_limit:
					if item.amount < item.stack_limit:
						print("if here")
						var diff = item.stack_limit - item.amount
						item.amount += diff
						new_item.amount -= diff
				else:
					item.amount += new_item.amount
					print("else here")
					return true
	
	if new_item.amount > 0:
		if _add_to_empty(new_item):
			return true
			
	return false

func _add_to_empty(item: Item) -> bool:
	for i in range(_size):
		if _contents[i] == null:
			_contents[i] = item
			return true
	return false

# Add an Inventory.new() to the player script
# Let him call pickup() on objects to interact with world items and add them to inventory
# this can interface with the inventory hud and slots 
