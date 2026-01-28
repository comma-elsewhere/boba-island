class_name PlayerHUD extends Node3D

signal slot_selected(slot_item: Item)

@export var fill: Array[Item] = []
@export var view_model: Marker3D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var hotbar_display: HBoxContainer = %HotbarContainer
@onready var pause_menu: PanelContainer = %PauseMenu
@onready var library_interface: Control = %LibraryInterface

const MAIN_MENU := "res://scenes/level/main_menu.tscn"

const OFFSET := Vector3(0.5, -0.2, -1.0)

var inventory: InventoryCraft
var hotbar_array: Array[Item]
var selected_slot: int = 0
var gui_open: bool = false

func _ready() -> void:
	setup()
	library_interface.hide()
	pause_menu.quit_game.connect(quit_game)
	view_model.position = OFFSET
	inventory = InventoryCraft.new()
	
	for item in fill:
		add_item(item)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and canvas_layer.visible:
		if library_interface.visible:
			_toggle_library()
		else:
			pause()
	if event.is_action_pressed("library") and !pause_menu.visible and canvas_layer.visible:
		_toggle_library()
	
func reload() -> void:
	if Dynamic.inventory_space <= hotbar_array.size():
		return
	else:
		var diff = Dynamic.inventory_space - hotbar_array.size()
		var extra_slot_index = Dynamic.inventory_space
		while diff > 0:
			hotbar_array.append(null)
			_create_hotbar_button(extra_slot_index - diff + 1)
			diff -= 1
		
		hotbar_display.update_slots()
		
		#_update_display(0)
		#selected_slot = 0
	
func setup() -> void:
	for child in hotbar_display.get_children():
		child.queue_free()
	for i in Dynamic.inventory_space:
		hotbar_array.append(null)
		_create_hotbar_button(i + 1)
		
	hotbar_display.get_slots()
	
func _toggle_library() -> void:
	library_interface.visible = !library_interface.visible
	if library_interface.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func plant_crop(pos: Vector3) -> bool:
	var selected = hotbar_array[selected_slot]
	if selected != null and selected.has_method("am_seed"):
		var new_crop: WorldCrop = selected.crop_scene.instantiate() as WorldCrop
		new_crop.crop_data = selected.crop_data
		get_tree().current_scene.add_child(new_crop)
		new_crop.global_position = pos
		erase_selected()
		return true
	else: 
		return false
	
func get_inventory() -> InventoryCraft:
	inventory.clear_all()
	for item in hotbar_array:
		inventory.add_item(item)
	return inventory
	
func return_items(resultant: InventoryCraft) -> void:
	if resultant != null:
		hotbar_array.clear()
		for item in resultant.get_items():
			if !add_item(item):
				reject_item(item)

func add_item(item: Item) -> bool:
	hotbar_array.resize(Dynamic.inventory_space)
	for i in range(Dynamic.inventory_space):
		if hotbar_array[i] == null:
			hotbar_array[i] = item
			#_update_display(i)
			_on_hotbar_container_slot_selected(i)
			return true
	return false

func remove_item(item: Item) -> void:
	for i in len(hotbar_array):
		if hotbar_array[i] == item:
			hotbar_array.erase(hotbar_array[i])
			_update_display(i)
			return

func remove_item_name(item_name: String) -> void:
	for i in len(hotbar_array):
		if hotbar_array[i] != null:
			if hotbar_array[i].name == item_name:
				hotbar_array.erase(hotbar_array[i])
				_update_display(i)
				return

func erase_selected() -> void:
	var item = hotbar_array[selected_slot]
	if item != null:
		hotbar_array[selected_slot] = null
		_update_display(selected_slot)
	
func drop_item(_drop_position: Vector3) -> void:
	var dropped_item = hotbar_array[selected_slot]
	if dropped_item != null:
		_spawn_item(dropped_item)
		hotbar_array[selected_slot] = null
		_update_display(selected_slot)
	
func reject_item(item: Item) -> void:
	_spawn_item(item)
	
func quit_game() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
	
func pause() -> void:
	if !gui_open:
		if get_tree().paused == false:
			pause_menu.open()
		else:
			pause_menu.close()
			%Reticle.update_visible()
	else:
		get_tree().call_group("GUI_Event", "close")
	
func close() -> void:
	gui_open = false
	hotbar_array.resize(Dynamic.inventory_space)
	_update_display(0)
	selected_slot = 0
	hotbar_display.show()
	
func mutant_encounter(active: bool) -> void:
	canvas_layer.visible = !active
	if !canvas_layer.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _spawn_item(item: Item) -> void:
	var interactable = item.interactable.instantiate()
	interactable.set_data(item)
	get_tree().current_scene.add_child(interactable)
	interactable.global_position = get_tree().get_first_node_in_group("Player").csg_spawner.global_position
	
func _update_display(index: int) -> void:
	hotbar_display.update_hotbar(hotbar_array)
	hotbar_display.highlight_slot(index)
	#view_model.update_held_item(hotbar_array[index])
	
func _on_hotbar_container_slot_selected(index: int) -> void:
	selected_slot = clamp(index, 0, Dynamic.inventory_space - 1)
	_update_display(selected_slot)
	slot_selected.emit(hotbar_array[selected_slot])

func _create_hotbar_button(keybind: int) -> void:
	var new_button = HotbarButton.new()
	hotbar_display.add_child(new_button)
	var hotkey: Shortcut = Shortcut.new()
	var key_event = InputEventKey.new()
	key_event.keycode = OS.find_keycode_from_string(str(keybind))
	key_event.pressed = true
	hotkey.events = [key_event]
	new_button.set_shortcut(hotkey)
