extends SlotItem

var interactable: bool = false

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	
func _on_gui_input(event: InputEvent) -> void:
	var held_item: DragItem = get_tree().get_first_node_in_group("DraggableItem") as DragItem
	if event is InputEventMouseButton:
		if item_data and !held_item and interactable:
			_make_item_draggable(item_data)
	
func _make_item_draggable(item: Item) -> void:
	var new_draggable = DragItem.new()
	new_draggable.item_data = item
	get_tree().root.add_child(new_draggable)
