class_name UpgradeButton extends MenuButton

signal upgrade_selected

const DEFAULT_ONE := ["Inventory Upgrade (+2 Slots)", "New crop: Cassava (Tapioca)", "New ingredient: Matcha Powder", "New tea: Oolong"]
const DEFAULT_TWO := ["New ingredient: Milk", "New tea: Moroccan Mint", "New tea: Masala Chai"]
const DEFAULT_THREE := ["New crop: Taro", "New tea: Assam Black", "New tea: Jasmine Green"]
const DEFAULT_FOUR := ["New crop: Strawberries", "New tea: Earl Grey", "New tea: Hojicha"]

var self_index: int

func _ready() -> void:
	disabled = true

func set_control_sibling(sibling: DebtStep) -> void:
	sibling.goal_maxed.connect(_self_activate)
	
func add_menu_items(index: int, upgrade_array: Array[Upgrade]) -> void:
	self_index = index
	_add_default_items()
	var id_num: int = 10
	for i in len(upgrade_array):
		get_popup().add_radio_check_item(upgrade_array[i].upgrade_name, id_num)
		get_popup().set_item_metadata(get_popup().get_item_index(id_num), upgrade_array[i])
		id_num -= 1
	get_popup().id_pressed.connect(_upgrade_selected)
	
func _self_activate(_node: DebtStep) -> void:
	disabled = false

func _upgrade_selected(id: int) -> void:
	var upgrade: Upgrade = get_popup().get_item_metadata(get_popup().get_item_index(id))
	if upgrade == null:
		return
	else:
		upgrade_selected.emit()
		disabled = true
		upgrade.upgrade(self_index)

func _add_default_items() -> void:
	var new_items: Array = []
	match self_index:
		0: new_items = DEFAULT_ONE
		1: new_items = DEFAULT_TWO
		2: new_items = DEFAULT_THREE
		3: new_items = DEFAULT_FOUR
		
	var id_num = 0
	if !new_items.is_empty():
		for item in new_items:
			get_popup().add_item(item)
			get_popup().set_item_metadata(id_num, null)
			id_num += 1
			
	_add_tooltip_text(new_items)
		
	get_popup().add_separator("Upgrade Options")
	
	
func _add_tooltip_text(items: Array) -> void:
	var all_items: String
	for i in len(items):
		all_items += items[i] + "\n"
		
	all_items += "Choice of Two Upgrade Options"
		
	tooltip_text = all_items
