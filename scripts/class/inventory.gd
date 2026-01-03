class_name Inventory extends Node

var _contents: Array[Item] = []

func add_item(item: Item) -> Item:
	if !_contents.is_empty():
		_stack(item)
	else:
		_contents.append(item)
	
	# If inventory is full it spits back the last thing you put in it after it tries to stack
	if _contents.size() > 24: # REPLACE WITH GLOBAL VAR
		return _contents.pop_back()
	else:
		return null
	
func remove_item(item: Item) -> void:
	_contents.erase(item)
	
func get_items() -> Array[Item]:
	return _contents
	
func has_all(items: Array[Item]) -> bool:
	var needed: Array[Item] = items.duplicate()
	
	for available in _contents:
		needed.erase(available)
		
	return needed.is_empty()
	
	
func _stack(new_item: Item) -> void:
	for item in _contents:
		if item.name == new_item.name:
			var amount_sum = item.amount - new_item.amount
			if amount_sum > item.stack_limit:
				if item.amount < item.stack_limit:
					var diff = item.stack_limit - item.amount
					item.amount += diff
					new_item.amount -= diff
			else:
				item.amount += new_item.amount
				new_item.queue_free()

	if new_item:
		if new_item.amount > 0:
			_contents.append(new_item)


# Add an Inventory.new() to the player script
# Let him call pickup() on objects to interact with world items and add them to inventory
# this can interface with the inventory hud and slots 
