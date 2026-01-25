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
	
func _moisture_loss() -> void:
	if Dynamic.moisture_loss > 0.1:
		Dynamic.moisture_loss -= 0.4
	
func _grow_speed() -> void:
	if Dynamic.grow_mod > 0.5:
		Dynamic.grow_mod /= 2
	
func _crop_yield() -> void:
	if Dynamic.crop_yield < 4:
		Dynamic.crop_yield += 1
	
func _processor() -> void:
	if Dynamic.process_speed > 0.25:
		Dynamic.process_speed /= 2
	
func _cooker() -> void:
	if Dynamic.cook_speed > 0.25:
		Dynamic.cook_speed /= 2
	
func _mixer() -> void:
	if Dynamic.mix_speed > 0.25:
		Dynamic.mix_speed /= 2

func _default(index: int) -> void:
	if index < 4:
		match index:
			0: _default_one()
			1: _default_two()
			2: _default_three()
			3: _default_four()

# UNLOCK CASSAVA, MATCHA, OOLONG
func _default_one() -> void:
	Dynamic.unlocked_crop[Static.CROP.CASSAVA] = Static.CROP.CASSAVA + 1
	Dynamic.unlocked_tea[Static.TEA.MATCHA] = Static.TEA.MATCHA + 1
	Dynamic.unlocked_tea[Static.TEA.OOLONG] = Static.TEA.OOLONG + 1
	
	Dynamic.cooker = 2 # adds boba
	Dynamic.mixer = 2 # adds plain boba tea
	Dynamic.processor = 2 # adds tapioca pearls
	
# UNLOCK MILK, MINT, CHAI
func _default_two() -> void:
	Dynamic.unlocked_tea[Static.TEA.MINT] = Static.TEA.MINT + 1
	Dynamic.unlocked_tea[Static.TEA.CHAI] = Static.TEA.CHAI + 1
	
	Dynamic.mixer = 3 # adds milk teas
	
# UNLOCK TARO, ASSAM, JASMINE
func _default_three() -> void:
	Dynamic.unlocked_crop[Static.CROP.TARO] = Static.CROP.TARO + 1
	Dynamic.unlocked_tea[Static.TEA.TARO] = Static.TEA.TARO + 1
	Dynamic.unlocked_tea[Static.TEA.ASSAM] = Static.TEA.ASSAM + 1
	Dynamic.unlocked_tea[Static.TEA.JASMINE] = Static.TEA.JASMINE + 1
	
	Dynamic.processor = 3 # adds taro puree
	
#UNLOCK STRAWBERRIES, EARL GREY, HOJICHA
func _default_four() -> void:
	Dynamic.unlocked_crop[Static.CROP.STRAWBERRY] = Static.CROP.STRAWBERRY + 1
	Dynamic.unlocked_tea[Static.TEA.EARL_GREY] = Static.TEA.EARL_GREY + 1
	Dynamic.unlocked_tea[Static.TEA.HOJICHA] = Static.TEA.HOJICHA + 1
	
	Dynamic.mixer = 4 # adds strawberry drinks
	Dynamic.processor = 4 # adds strawberry puree
