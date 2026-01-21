class_name Drink extends Item

@export_enum("Black", "Green", "Oolong", "Taro", "Matcha") var tea_type: String = ""
@export_enum("Plain", "Boba", "Milk", "Milk Boba", "Strawberry Milk", "Strawberry Boba") var drink_type: int
@export_range(1.0, 4.0, 0.5) var price_multiplier: float = 1
var tea_flavor: int

func get_drink_name() -> String:
	return tea_type + " " + name

func set_tea_flavor(flavor_num: int) -> void:
	tea_flavor = flavor_num
	if flavor_num == Static.TEA.TARO:
		tea_type = "Taro"
	elif flavor_num == Static.TEA.MATCHA:
		tea_type = "Matcha"
	elif flavor_num == Static.TEA.OOLONG:
		tea_type = "Oolong"
	elif flavor_num >= Static.TEA.HOJICHA:
		tea_type = "Green"
	else: 
		tea_type = "Black"
