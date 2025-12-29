extends HBoxContainer

signal slot_selected(index: int)

var slots: Array = []

func _ready():
	get_slots()

func get_slots():
	slots = get_children()
	for slot in slots:
		slot.pressed.connect(_select_slot.bind(slot.get_index()))

func update_hotbar(items: Array[Item]):
	for slot in slots:
		var item = items[slot.get_index()]
		if item != null:
			slot.texture_normal = item.icon

func highlight_slot(slot_index: int):
	for i in range(slots.size()):
		slots[i].modulate = Color(1,1,1)
	slots[slot_index].modulate = Color(1.5, 1.5, 1.5)

func _select_slot(slot_index: int) -> void:
	slot_selected.emit(slot_index)
