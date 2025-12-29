extends SlotItem

signal item_taken(idx: int)
signal item_placed(item: Item, idx: int)

var index: int = -1

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var held_item: DragItem = get_tree().get_first_node_in_group("DraggableItem") as DragItem
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if held_item:
				if !item_data:
					_place_item(held_item)
				else:
					if item_data.name != held_item.item_data.name:
						_swap_items(held_item, item_data)
						return
					_stack_items(held_item, item_data)
			else:
				if item_data:
					_pick_item(item_data)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if held_item:
				if !item_data:
					_place_one(held_item)
				else:
					if item_data.name != held_item.item_data.name:
						return
					_stack_one(held_item, item_data)
			else:
				if item_data:
					_split()


func _stack_one(held_item: DragItem, current_item: Item) -> void:
	var sum_amount = held_item.item_data.amount + 1
	if sum_amount > current_item.stack_limit:
		return
	_stack(1)
	held_item.item_data.amount -= 1
	if held_item.item_data.amount < 1:
		held_item.queue_free()
	else:
		held_item.update_amount_label()
	
	
func _stack_items(held_item: DragItem, current_item: Item) -> void:
	var sum_amount = held_item.item_data.amount + current_item.amount
	if sum_amount > current_item.stack_limit:
		if current_item.amount < current_item.stack_limit:
			var diff = current_item.stack_limit - current_item.amount
			_stack(diff)
			held_item.item_data.amount -= diff
			held_item.update_amount_label()
	else:
		_stack(held_item.item_data.amount)
		held_item.queue_free()
	
	
func _swap_items(held_item: DragItem, current_item: Item) -> void:
	var temp = current_item.duplicate()
	item_taken.emit(index)
	display(held_item.item_data)
	item_placed.emit(held_item.item_data, index)
	held_item.item_data = temp
	held_item.display_item(temp)
	held_item.update_amount_label()
	
	
func _place_item(held_item: DragItem) -> void:
	item_data = held_item.item_data
	display(held_item.item_data)
	item_placed.emit(held_item.item_data, index)
	held_item.queue_free()
	
	
func _pick_item(item: Item) -> void:
	_make_item_draggable(item)
	_clear_display()
	item_taken.emit(index)
	
	
func _make_item_draggable(item: Item) -> void:
	var new_draggable = DragItem.new()
	new_draggable.item_data = item
	get_tree().root.add_child(new_draggable)
	
	
func _clear_display() -> void:
	item_data = null
	texture_rect.texture = null
	item_amount.text = ""
	item_name.text = ""
	
	
func _stack(amount: int) -> void:
	item_data.amount += amount
	_update_amount_label()
	item_placed.emit(item_data, index)
	
	
func _place_one(held_item: DragItem) -> void:
	held_item.item_data.amount -= 1
	var held_item_data: Item = held_item.item_data.duplicate()
	held_item_data.amount = 1
	display(held_item_data)
	
	if held_item.item_data.amount < 1:
		held_item.queue_free()
	else:
		held_item.update_amount_label()
	
	
func _split() -> void:
	if item_data.amount <= 1:
		return
	var draggable_item_data = item_data.duplicate()
	draggable_item_data.amount /= 2
	item_data.amount -= draggable_item_data.amount
		
	_make_item_draggable(draggable_item_data)
	_update_amount_label()
	item_placed.emit(item_data, index)
