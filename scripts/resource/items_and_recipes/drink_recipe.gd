class_name DrinkRecipe extends Recipe

@export var tea_base: TeaBase = preload("res://resources/game_data/tea/tea_base.tres")

func check_tea_base(potential_tea: Item) -> bool:
	var tea_index: int = tea_base.tea_array.find(potential_tea)
	if tea_index > -1:
		result.set_tea_flavor(tea_index)
		return true
	else:
		return false
