class_name RecipeUpgradeGroup extends Resource

@export var upgrade_0: Array[Recipe] = []
@export var upgrade_1: Array[Recipe] = []
@export var upgrade_2: Array[Recipe] = []
@export var upgrade_3: Array[Recipe] = []
@export var upgrade_4: Array[Recipe] = []
@export var upgrade_5: Array[Recipe] = []

var _upgrade_array: Array[Array]

func upgrade(upgrade_index: int) -> Array[Recipe]:
	_upgrade_array = [upgrade_0, upgrade_1, upgrade_2, upgrade_3, upgrade_4, upgrade_5]
	return _upgrade_array[upgrade_index]
