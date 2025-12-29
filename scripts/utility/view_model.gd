extends Marker3D

var current_item_instance: Node3D = null

func _clear_item() -> void:
	if current_item_instance:
		current_item_instance.queue_free()
		current_item_instance = null

func _show_item(item_data: Item) -> void:
	if item_data and item_data.mesh:
		current_item_instance = item_data.mesh.instantiate()
		current_item_instance.position = Vector3.ZERO
		current_item_instance.rotation = Vector3.ZERO
		add_child(current_item_instance)

func update_held_item(new_item: Item) -> void:
	_clear_item()
	if new_item != null:
		_show_item(new_item)
