class_name SlotItem extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var item_name: Label = %ItemName
@onready var item_amount: Label = %ItemAmount

var item_data: Item = null

func display(item: Item):
	if item:
		item_name.text = item.name
		texture_rect.texture = item.icon
		item_data = item
		_update_amount_label()
			
	else: return

func _update_amount_label() -> void:
	if item_data.amount > 1:
		item_amount.text = str(item_data.amount)
		item_amount.show()
	else:
		item_amount.hide()
