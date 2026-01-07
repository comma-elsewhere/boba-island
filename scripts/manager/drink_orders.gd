extends Control

@export var drinks: RecipeUpgradeGroup

var drink_order: Drink
var available_drinks: Array[Drink]

func _ready() -> void:
	get_available_drinks()

func get_available_drinks() -> void:
	available_drinks.clear()
	for i in range(Dynamic.mixer):
		var index: String = "upgrade_" + str(i)
		for j in drinks[index]:
			available_drinks.append(j.result)
	
func pick_rand_drink() -> Drink:
	var rand_drink: Drink = available_drinks.pick_random()
	if rand_drink.name == "Tea" or rand_drink.name == "Boba Tea":
		rand_drink.set_tea_flavor(randi_range(0,8))
	else:
		rand_drink.set_tea_flavor(randi_range(0,10))
	return rand_drink
