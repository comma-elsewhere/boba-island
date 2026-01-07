extends Control

@export var drinks: RecipeUpgradeGroup

var available_drinks: Array[Recipe]

func _ready() -> void:
	get_available_drinks()
	Dynamic.drink_order = pick_rand_drink()

func get_available_drinks() -> void:
	available_drinks.clear()
	for i in range(Dynamic.mixer):
		var index: String = "upgrade_" + str(i)
		for j in drinks[index]:
			available_drinks.append(j)
	
func pick_rand_drink() -> Recipe:
	var rand_drink: Recipe = available_drinks.pick_random()
	if rand_drink.result.name == "Tea" or rand_drink.result.name == "Boba Tea":
		rand_drink.result.set_tea_flavor(randi_range(0,8))
	else:
		rand_drink.result.set_tea_flavor(randi_range(0,10))
	return rand_drink
