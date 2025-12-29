extends PanelContainer

@onready var inventory_grid: InventoryGrid = %InventoryGrid

var inventory_size: int = 24 # Can be set to global var for upgradeable-ness
var complete_inventory: Array[Item] = []


func open(inventory: Inventory) -> void:
	complete_inventory = _init_inventory(inventory.get_items())
	inventory_grid.item_taken.connect(_on_item_taken)
	inventory_grid.item_placed.connect(_on_item_placed)
	inventory_grid.display(complete_inventory)
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	
	
func close() -> Array[Item]:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Theoretically this puts all null slots in the back and then erases them from the inventory
	complete_inventory.sort_custom(func(a,b): return a != null and b == null) 
	var first_null = complete_inventory.bsearch(null)
	for i in len(complete_inventory.size()):
		if i > first_null:
			complete_inventory.erase(complete_inventory[i])
	
	return complete_inventory

func _init_inventory(items: Array[Item]) -> Array[Item]:
	items.append_array(_add_empty_slots(items))
	return items
	
func _add_empty_slots(items: Array[Item]) -> Array:
	var empty_slots: Array = []
	empty_slots.resize(inventory_size - items.size())
	empty_slots.fill(null)
	return empty_slots
	
func _on_item_taken(index: int) -> void:
	complete_inventory[index] = null
	
func _on_item_placed(item: Item, index: int) -> void:
	complete_inventory[index] = item
