class_name StorageHUD extends PanelContainer

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var inventory_grid: InventoryGrid = %InventoryGrid

const RIGHT_CLICK := "Right click to remove items from inventory."

var inventory_size: int = 18 # Can be set to global var for upgradeable-ness
var complete_inventory: Array[Item] = []
var label: Label

func _ready() -> void:
	inventory_grid.item_taken.connect(_on_item_taken)
	inventory_grid.item_placed.connect(_on_item_placed)
	inventory_grid.return_item.connect(_on_item_returned)
	_init_inventory(complete_inventory)
	update_display()

func open() -> void:
	player.hud.slot_selected.connect(_store_item)
	
func close() -> void:
	if player.hud.slot_selected.is_connected(_store_item):
		player.hud.slot_selected.disconnect(_store_item)

func update_display() -> void:
	inventory_grid.display(complete_inventory)
	
	if label:
		label.queue_free()
	label = Label.new()
	add_child(label)
	label.text = RIGHT_CLICK

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

func _on_item_returned(item: Item) -> void:
	player.hud.add_storage_item(item)

func _store_item(item: Item) -> void:
	if item == null:
		return
	var new_item = item.duplicate()
	if !complete_inventory.is_empty():
		if _stack(new_item):
			_item_added()
	else:
		if _add_to_empty(new_item):
			_item_added()
		else:
			player.hud.reject_item(new_item)
	
func _item_added() -> void:
	player.hud.erase_selected()
	inventory_grid.display(complete_inventory)

func _add_to_empty(item: Item) -> bool:
	for i in range(inventory_size):
		if complete_inventory[i] == null:
			complete_inventory[i] = item
			return true
	return false

func _stack(new_item: Item) -> bool:
	for item in complete_inventory:
		if item == null:
			pass
		else:
			if item.name == new_item.name:
				var amount_sum = item.amount + new_item.amount
				if amount_sum > item.stack_limit:
					if item.amount < item.stack_limit:
						var diff = item.stack_limit - item.amount
						item.amount += diff
						new_item.amount -= diff
				else:
					item.amount += new_item.amount
					return true
	
	if new_item.amount > 0:
		if _add_to_empty(new_item):
			return true
			
	return false
