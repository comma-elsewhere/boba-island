extends Node

@export var hotbar_display: HBoxContainer
@export var view_model: Marker3D

const HOTBAR_SIZE := 4
var hotbar_array: Array[Item]
var selected_slot: int = 0

func _init():
	for i in HOTBAR_SIZE:
		hotbar_array.append( null )

func add_item(item: Item) -> bool:
	for i in HOTBAR_SIZE:
		if hotbar_array[i] == null:
			hotbar_array[i] = item
			_update_display(i)
			return true
	return false

func drop_item() -> void:
	var dropped_item = hotbar_array[selected_slot]
	_spawn_item(dropped_item)
	hotbar_array[selected_slot] = null
	_update_display(selected_slot)
	
func _spawn_item(item : Item) -> void:
	var interactable = item.interactable.instantiate()
	interactable.item_data = item
	get_tree().current_scene.add_child(interactable)

	
func _update_display(index: int) -> void:
	hotbar_display.update_hotbar(hotbar_array)
	hotbar_display.highlight_slot(index)
	view_model.update_held_item(hotbar_array[index])
	

func _on_hotbar_container_slot_selected(index: int) -> void:
	selected_slot = clamp(index, 0, HOTBAR_SIZE - 1)
	_update_display(selected_slot)
