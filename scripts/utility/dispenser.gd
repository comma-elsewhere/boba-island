extends StaticBody3D

@export var item_data: Item

@onready var item_texture: TextureRect = %ItemTexture
@onready var item_label: Label = %ItemLabel
@onready var item_price: Label = %ItemPrice


func _ready() -> void:
	visible = _hide_self(item_data.name)
	
	item_texture.texture = item_data.icon
	item_label.text = item_data.name
	
	if item_data.has_method("am_seed"):
		item_price.text = Kinetic.display_money(int(float(Dynamic.seed_cost) * item_data.price_mod))
	else:
		item_price.hide()
		
func reload() -> void:
	visible = _hide_self(item_data.name)
		
		
func pickup() -> Item:
	if visible == false:
		return null
	if item_data.has_method("am_seed"):
		if item_data.buy_seed(): # Returns true if you have enough money, subs the price of seed
			%ChaChingSound.play()
			return item_data
		else: return null
	# If item is not seed
	else: return item_data

func _hide_self(my_item: String) -> bool:
	if my_item == "Cassava Cutting" and Dynamic.unlocked_crop[Static.CROP.CASSAVA] == null:
		return false
	elif my_item == "Strawberry Sprout" and Dynamic.unlocked_crop[Static.CROP.STRAWBERRY] == null:
		return false
	elif my_item == "Taro Cutting" and Dynamic.unlocked_crop[Static.CROP.TARO] == null:
		return false
	elif my_item == "Milk" and Dynamic.mixer < 3:
		return false
	elif my_item == "Matcha Powder" and Dynamic.unlocked_tea[Static.TEA.MATCHA] == null:
		return false
	else:
		return true
