extends StaticBody3D

@onready var inventory_hud: PanelContainer = %InventoryHUD
@onready var player: Player = get_tree().get_first_node_in_group("Player")

var _storage_inventory: InventoryStorage

func _ready() -> void:
	rotation_degrees.y = 90.0
	scale = Vector3(0.35, 0.35, 0.35)
	$CanvasLayer.hide()
	_storage_inventory = InventoryStorage.new()
	_storage_inventory.init_with_empty(inventory_hud.inventory_size)
	
func init_gui_scene() -> void:
	$CanvasLayer.show()
	inventory_hud.open(_storage_inventory)
	player.hud.slot_selected.connect(_store_item)

func close() -> void:
	$CanvasLayer.hide()
	_storage_inventory._contents = inventory_hud.close()
	if player.hud.has_connections("slot_selected"):
		player.hud.slot_selected.disconnect(_store_item)

func _store_item(item: Item) -> void:
	if item == null:
		return
	else:
		if _storage_inventory.add_item(item):
			player.hud.erase_selected()
			inventory_hud.update_display(_storage_inventory)
	
func _on_inventory_grid_return_item(item: Item) -> void:
	_storage_inventory.remove_item(item)
	player.hud.add_item(item)
	
func on_save(save_data: Array[SavedData]) -> void:
	var my_data: SavedGUI = SavedGUI.new()
	my_data.position = global_position
	my_data.scene_file_path = scene_file_path
	my_data.storage_items = _storage_inventory.get_items()
	
	save_data.append(my_data)

func on_preload() -> void:
	get_parent().remove_child(self)
	queue_free()

func on_load(save_data: SavedData) -> void:
	var my_data: SavedGUI = save_data as SavedGUI
	global_position = my_data.position
	
	for item in my_data.storage_items:
		_storage_inventory.add_item(item)
