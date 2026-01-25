extends HBoxContainer

signal slot_selected(index: int)

var slots: Array = []

func get_slots():
	slots = get_children()
	for slot in slots:
		slot.pressed.connect(_select_slot.bind(slot.get_index()))

func update_hotbar(items: Array[Item]):
	for i in len(items):
		var item = items[i]
		if item != null:
			slots[i].texture_normal = item.icon
			slots[i].set_label(item.name)
		else:
			slots[i].texture_normal = null
			slots[i].set_label("")

func highlight_slot(slot_index: int):
	for i in range(slots.size()):
		slots[i].modulate = Color(1,1,1)
	slots[slot_index].modulate = Color(1.75, 1.75, 1.75)

func _select_slot(slot_index: int) -> void:
	slot_selected.emit(slot_index)
