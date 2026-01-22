extends StaticBody3D

@onready var inventory_hud: PanelContainer = %InventoryHUD
@onready var player: Player = get_tree().get_first_node_in_group("Player")

var _storage_inventory: Inventory

func _ready() -> void:
	$CanvasLayer.hide()
	_storage_inventory = Inventory.new()
	_storage_inventory.init_with_empty(inventory_hud.inventory_size)
	player.hud.slot_selected.connect(_store_item)

func init_gui_scene() -> void:
	$CanvasLayer.show()
	inventory_hud.open(_storage_inventory)

func close() -> void:
	$CanvasLayer.hide()
	_storage_inventory._contents = inventory_hud.close()

func _store_item(item: Item) -> void:
	if item == null:
		return
	else:
		if _storage_inventory.add_item(item):
			player.hud.erase_selected()
			print(_storage_inventory.get_items())
			inventory_hud.update_display(_storage_inventory)
	
func _on_inventory_grid_return_item(item: Item) -> void:
	_storage_inventory.remove_item(item)
	player.hud.add_item(item)
	
