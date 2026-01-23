extends Node3D

@onready var drink_orders: DrinkOrders = %DrinkOrders

var drink_bodies: Array[WorldItem] = []
var drinks_in_area: Array[Drink] = []
var ordered_drink: Drink = null
var served_drink: Drink = null

func on_click() -> void:
	if drink_orders.next_dialogue_button.disabled == false:
		drink_orders.continue_dialogue()
	elif drink_orders.serve_drink_button.visible == true:
		drink_orders.serve_drink()

func _check_drinks() -> void:
	var drink_found: bool = false
	for drink in drinks_in_area:
		if drink.drink_type == ordered_drink.drink_type:
			drink_orders.activate_serve_button(true)
			served_drink = drink
			drink_found = true
			return
	if !drink_found:
		drink_orders.activate_serve_button(false)

func _erase_drink(drink: Drink) -> void:
	var index = drinks_in_area.find(drink)
	if index >= 0:
		drink_bodies.pop_at(index).call_deferred("queue_free")
		drinks_in_area.remove_at(index)

func _calc_paid() -> int:
	return int(Dynamic.base_price * ordered_drink.price_multiplier)
	
func _calc_tipped() -> int:
	var tip: float
	if served_drink.tea_flavor == Dynamic.tea_flavor:
		tip = Dynamic.starting_tip * served_drink.quality
	#elif served_drink.tea_type == ordered_drink.tea_type:
		#tip = Dynamic.starting_tip * served_drink.quality /2
	else:
		tip = 0
	return int(tip)

func _on_area_3d_body_entered(body: Node3D) -> void:
	drink_bodies.append(body)
	drinks_in_area.append(body.item_data)
	if ordered_drink != null:
		_check_drinks()

func _on_area_3d_body_exited(body: Node3D) -> void:
	#"exit"
	drink_bodies.erase(body)
	drinks_in_area.erase(body.item_data)
	if !drinks_in_area.is_empty() and ordered_drink != null:
		_check_drinks()

func _on_drink_orders_drink_ordered(drink: Drink) -> void:
	ordered_drink = drink
	if !drinks_in_area.is_empty():
		_check_drinks()

func _on_drink_orders_drink_served() -> void:
	drink_orders.finish_order(_calc_paid(), _calc_tipped())
	_erase_drink(served_drink)
	served_drink = null
	ordered_drink = null
