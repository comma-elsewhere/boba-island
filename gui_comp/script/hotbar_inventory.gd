class_name PlayerHUD extends Node

@onready var hotbar_display: HBoxContainer = %HotbarContainer
@onready var pause_menu: PanelContainer = %PauseMenu
@onready var view_model: Marker3D = %ViewModel


var hotbar_array: Array[Item]
var selected_slot: int = 0

func _ready() -> void:
	setup()
	pause_menu.quit_game.connect(quit_game)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()
	
func setup() -> void:
	for child in hotbar_display.get_children():
		child.queue_free()
	for i in Dynamic.inventory_space:
		hotbar_array.append( null )
		_create_hotbar_button(i + 1)
		
	hotbar_display.get_slots()

func add_item(item: Item) -> bool:
	for i in Dynamic.inventory_space:
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
	
func quit_game() -> void:
	get_tree().quit()
	
func pause() -> void:
	if get_tree().paused == false:
		pause_menu.open()
	else:
		pause_menu.close()
	
func _spawn_item(item : Item) -> void:
	var interactable = item.interactable.instantiate()
	interactable.item_data = item
	get_tree().current_scene.add_child(interactable)

	
func _update_display(index: int) -> void:
	hotbar_display.update_hotbar(hotbar_array)
	hotbar_display.highlight_slot(index)
	view_model.update_held_item(hotbar_array[index])
	

func _on_hotbar_container_slot_selected(index: int) -> void:
	selected_slot = clamp(index, 0, Dynamic.inventory_space - 1)
	_update_display(selected_slot)

func _create_hotbar_button(keybind: int) -> void:
	var new_button = HotbarButton.new()
	hotbar_display.add_child(new_button)
	var hotkey: Shortcut = Shortcut.new()
	var key_event = InputEventKey.new()
	key_event.keycode = OS.find_keycode_from_string(str(keybind))
	key_event.pressed = true
	hotkey.events = [key_event]
	new_button.set_shortcut(hotkey)
