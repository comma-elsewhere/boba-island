class_name RecipeUpgradeGroup extends Resource

@export var upgrade_0: Array[Recipe] = []
@export var upgrade_1: Array[Recipe] = []
@export var upgrade_2: Array[Recipe] = []
@export var upgrade_3: Array[Recipe] = []

var _upgrade_array: Array[Array]

func upgrade(upgrade_index: int) -> Array[Recipe]:
	_upgrade_array = [upgrade_0, upgrade_1, upgrade_2, upgrade_3]
	return _upgrade_array[upgrade_index]
