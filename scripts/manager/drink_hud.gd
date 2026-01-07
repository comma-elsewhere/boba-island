extends CraftingHUD

@onready var tea_list: OptionButton = %TeaBase

var tea_array: Array[Item] = []

func _ready() -> void:
	_populate_tea_items()
	tea_list.item_selected.connect(_check_tea)
	
func _populate_tea_items() -> void:
	for tea in Dynamic.drink_order.tea_base.tea_array:
		if _inventory.has(tea):
			tea_array.append(tea)
	
	if tea_array.is_empty():
		return
		
	for item in len(tea_array):
		tea_list.add_icon_item(tea_array[item].icon, tea_array[item].name, item)
		tea_list.set_item_metadata(item, tea_array[item])

func _check_tea(index: int) -> void:
	var item: Item = tea_list.get_item_metadata(index)
	if not Dynamic.drink_order.check_tea_base(item):
		crafting_check[1] = 1
	else:
		crafting_check[1] = 0
