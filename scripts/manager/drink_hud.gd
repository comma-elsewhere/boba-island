extends CraftingHUD

@export var tea_base: TeaBase

@onready var tea_list: OptionButton = %TeaList

var tea_array: Array[Item] = []
var selected_tea: Item = null

func _ready() -> void:
	crafting_check.resize(2)
	super()
	tea_list.item_selected.connect(_check_tea)
		
func open() -> void:
	super()
	crafting_check = [0,0]
	
func close() -> void:
	super()
	
func _on_crafting_button_button_up() -> void:
	super()
	if selected_tea != null:
		player.hud.remove_item(selected_tea)
		
	_populate_tea_items()
	
func _on_recipe_list_item_selected(index: int) -> void:
	super(index)
	_populate_tea_items()
	
func _populate_tea_items() -> void:
	tea_array.clear()
	tea_list.clear()
	
	var inventory: Array[Item] = player.hud.hotbar_array
	for i in len(inventory):
		if inventory[i] != null:
			for j in len(tea_base.tea_array):
				if inventory[i].name == tea_base.tea_array[j].name:
					tea_array.append(inventory[i])

	if tea_array.is_empty():
		return
		
	for i in len(tea_array):
		tea_list.add_item(tea_array[i].name, i)
		tea_list.set_item_metadata(i, tea_array[i])
		
	_check_tea(0)

func _check_tea(index: int) -> void:
	var item: Item = tea_list.get_item_metadata(index)
	selected_tea = item
	if item == null:
		crafting_check[1] = 0
	else:
		crafting_check[1] = 1
	print(crafting_check)
