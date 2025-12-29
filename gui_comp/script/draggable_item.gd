class_name DragItem extends TextureRect

var item_data : Item = null
var amount_label : Label

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = Vector2(150, 150)
	display_item(item_data)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_to_group("DraggableItem")
	
	amount_label = Label.new()
	add_child(amount_label)
	amount_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	update_amount_label()
	
func update_amount_label() -> void:
	if item_data.amount > 1:
		amount_label.text = str(item_data.amount)
		amount_label.show()
	else:
		amount_label.hide()
	
func display_item(new_item_data: Item) -> void:
	item_data = new_item_data
	texture = item_data.icon
	modulate = Color(0.75, 0.75, 0.75, 0.75)
	
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() - (get_rect().size / 2)
