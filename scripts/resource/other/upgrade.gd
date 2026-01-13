class_name Upgrade extends Resource

@export var upgrade_name: String
@export_enum("None", "Inventory", "Moisture Loss", "Grow Speed", "Crop Yield", "Processor", "Cooker", "Mixer", "Default") var aspect_one: int = 0
@export_enum("None", "Inventory", "Moisture Loss", "Grow Speed", "Crop Yield", "Processor", "Cooker", "Mixer") var aspect_two: int = 0
@export_enum("None", "Inventory", "Moisture Loss", "Grow Speed", "Crop Yield", "Processor", "Cooker", "Mixer") var aspect_three: int = 0

var _upgrade_array: Array[int] = []

func upgrade(index: int) -> void:
	_upgrade_array.append(aspect_one)
	_upgrade_array.append(aspect_two)
	_upgrade_array.append(aspect_three)
	
	if !_upgrade_array.is_empty():
		for function in _upgrade_array:
			match function:
				0: pass
				1: _inventory()
				2: _moisture_loss()
				3: _grow_speed()
				4: _crop_yield()
				5: _processor()
				6: _cooker()
				7: _mixer()
				8: _default(index)


func _inventory() -> void:
	if Dynamic.inventory_space < 9:
		Dynamic.inventory_space += 2
		print("Inventory")
	
func _moisture_loss() -> void:
	if Dynamic.moisture_loss > 0.5:
		Dynamic.moisture_loss -= 2.5
		print("Moist")
	
func _grow_speed() -> void:
	if Dynamic.grow_mod > 0.5:
		Dynamic.grow_mod /= 2
		print("Grow")
	
func _crop_yield() -> void:
	if Dynamic.crop_yield < 4:
		Dynamic.crop_yield += 1
		print("CROPS")
	
func _processor() -> void:
	if Dynamic.process_speed > 0.25:
		Dynamic.process_speed /= 2
		print("procressor")
	
func _cooker() -> void:
	if Dynamic.cook_speed > 0.25:
		Dynamic.cook_speed /= 2
		print("Cooker")
	
func _mixer() -> void:
	if Dynamic.mix_speed > 0.25:
		Dynamic.mix_speed /= 2
		print("MIXER")

func _default(index: int) -> void:
	if index < 4:
		match index:
			0: _default_one()
			1: _default_two()
			2: _default_three()
			3: _default_four()

func _default_one() -> void:
	print("ONE")
	Dynamic.mixer = 3
	Dynamic.unlocked_tea[Static.TEA.MATCHA] = Static.TEA.MATCHA + 1
	Dynamic.unlocked_tea[Static.TEA.OOLONG] = Static.TEA.OOLONG + 1
	
	
func _default_two() -> void:
	print("TWO")
	Dynamic.new_crop = 1
	Dynamic.unlocked_tea[Static.TEA.TARO] = Static.TEA.TARO + 1
	Dynamic.unlocked_tea[Static.TEA.MINT] = Static.TEA.MINT + 1
	Dynamic.unlocked_tea[Static.TEA.CHAI] = Static.TEA.CHAI + 1
	
	
func _default_three() -> void:
	print("TRHEE")
	Dynamic.new_crop = 2
	Dynamic.unlocked_tea[Static.TEA.ASSAM] = Static.TEA.ASSAM + 1
	Dynamic.unlocked_tea[Static.TEA.JASMINE] = Static.TEA.JASMINE + 1
	
	
func _default_four() -> void:
	print("FOUR")
	_inventory()
	Dynamic.unlocked_tea[Static.TEA.EARL_GREY] = Static.TEA.EARL_GREY + 1
	Dynamic.unlocked_tea[Static.TEA.HOJICHA] = Static.TEA.HOJICHA + 1
