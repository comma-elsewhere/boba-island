class_name ItemGrid extends GridContainer

@export var slot_item: PackedScene

func display(items: Array[Item]) -> void:
	for child in get_children():
		child.call_deferred("queue_free")
		
	for item in items:
		var new_slot = slot_item.instantiate()
		add_child(new_slot)
		new_slot.display(item)

# For tea slots only
func activate_children(active: bool) -> void:
	for child in get_children():
		child.interactable = active
