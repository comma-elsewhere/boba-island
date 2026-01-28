class_name DrinkOrders extends Control

signal drink_ordered(drink: Drink)
signal drink_served

@export var drinks: RecipeUpgradeGroup
@export var tourist_ratio: int = 1

@onready var customer_name: Label = %CustomerName
@onready var order_text: Label = %OrderText
@onready var serve_drink_button: Button = %ServeDrinkButton
@onready var next_dialogue_button: Button = %NextDialogueButton

const TEA_NUM := Static.NUMBER_OF_TEAS - 2
const MILK_NUM := Static.NUMBER_OF_TEAS

const ORDER_COMPLETE := "Order Completed!"
const CORRECT_DRINK := "Correct Drink! Customer paid "
#const LOVED_TEA := "\n And they loved the tea! So they tipped an extra "
const LOVED_TEA := "\n And they tipped an extra "
const WRONG_TEA := "\n But they didn't care for the tea..."

const MIN_WAIT := 1.0
const MAX_WAIT := 3.0

var available_drinks: Array[Recipe]
var order_generator: OrderGen
var regular_generator: NpcGen
var tourist_odds: Array[int] = [1]
var current_order: Drink
var current_dialogue: Array = []

# 1 = old_letter
# 2 = cult_doctrine, myth, unyieldy
# 3 = cult_flyer, gongfu

var awaiting_customer: bool = false

var _unlocked_tea: Array = []
var _unlocked_milk_tea: Array = []

func _ready() -> void:
	order_generator = OrderGen.new()
	regular_generator = NpcGen.new()
	regular_generator.books_reload.connect(_on_books_reload)
	_reset_labels()
	_get_available_tourists()
	_set_tourist_odds()
	_get_available_drinks()
	activate_serve_button(false)
	serve_drink_button.button_up.connect(serve_drink)
	next_dialogue_button.button_up.connect(continue_dialogue)
	$NextCustomerTimer.start(MIN_WAIT)
	
func reload() -> void:
	_get_available_drinks()
	_get_available_tourists()
	_set_tourist_odds()
	
func finish_order(paid: int, tipped: int) -> void:
	Dynamic.orders_filled += 1
	Dynamic.today_earned += paid
	Dynamic.tips_earned += tipped
	Dynamic.total_money += paid + tipped
	awaiting_customer = true
	next_dialogue_button.disabled = false
	customer_name.text = ORDER_COMPLETE
	if tipped < 1:
		order_text.text = CORRECT_DRINK + Kinetic.display_money(paid) + WRONG_TEA
	#elif tipped <= float(Dynamic.starting_tip)/2:
		#order_text.text = CORRECT_DRINK + Kinetic.display_money(paid) + LIKED_TEA + Kinetic.display_money(tipped)
	else:
		order_text.text = CORRECT_DRINK + Kinetic.display_money(paid) + LOVED_TEA + Kinetic.display_money(tipped)
	
func generate_new_order() -> String:
	var npc_or_tourist: int
	if Dynamic.tutorial_on:
		npc_or_tourist = 1
	else:
		npc_or_tourist = tourist_odds.pick_random()
	if npc_or_tourist > 0:
		customer_name.text = regular_generator.get_name(npc_or_tourist)
		current_dialogue = regular_generator.get_dialogue(npc_or_tourist)
		current_order = regular_generator.get_order(npc_or_tourist)
		return _activate_dialogue()
	else:
		customer_name.text = "Tourist:"
		current_order = _pick_rand_drink().result[0]
		return order_generator.make_order(current_order)
		
func activate_serve_button(active: bool) -> void:
	serve_drink_button.visible = active
	
func _activate_dialogue() -> String:
	awaiting_customer = false
	if current_dialogue.is_empty():
		return regular_generator.generic_order(current_order)
	else:
		if current_dialogue.size() > 1:
			next_dialogue_button.disabled = false
		else:
			next_dialogue_button.disabled = true
		return current_dialogue.pop_front()
		
func continue_dialogue() -> void:
	if awaiting_customer:
		_reset_labels()
		$NextCustomerTimer.start(randf_range(MIN_WAIT, MAX_WAIT))
		next_dialogue_button.disabled = true
	else:
		order_text.text = current_dialogue.pop_front()
		
	if current_dialogue.is_empty():
		next_dialogue_button.disabled = true
	
func serve_drink() -> void:
	drink_served.emit()
	activate_serve_button(false)
	
func _get_available_tourists() -> void:
	tourist_odds.clear()
	if Dynamic.mixer > 3:
		tourist_odds.append_array([1,2,3])
	elif Dynamic.mixer > 1:
		tourist_odds.append_array([1,2])
	else:
		tourist_odds.append_array([1])

func _get_available_drinks() -> void:
	available_drinks.clear()
	for i in range(Dynamic.mixer):
		var index: String = "upgrade_" + str(i)
		for j in drinks[index]:
			available_drinks.append(j)

	for i in range(TEA_NUM):
		if Dynamic.unlocked_tea[i] != null:
				_unlocked_tea.append(Dynamic.unlocked_tea[i])
				
	for i in range(MILK_NUM):
		if Dynamic.unlocked_tea[i] != null:
			_unlocked_milk_tea.append(Dynamic.unlocked_tea[i])
	
func _pick_rand_drink() -> Recipe:
	var rand_drink: Recipe = available_drinks.pick_random()
	var flavor: int
	if rand_drink.result[0].name == "Plain Tea" or rand_drink.result[0].name == "Boba Tea":
		flavor = _unlocked_tea.pick_random() -1
	else:
		flavor = _unlocked_milk_tea.pick_random() -1
	rand_drink.result[0].set_tea_flavor(flavor)
	Dynamic.tea_flavor = flavor
	return rand_drink.duplicate(true)

func _set_tourist_odds() -> void:
	var new_odds: int = tourist_odds.size() + tourist_ratio
	tourist_odds.resize(new_odds)

func _reset_labels() -> void:
	order_text.text = ""
	customer_name.text = ""
	current_order = null

func _rand_available_flavor(max_range: int) -> int:
	var available_flavors: Array = Dynamic.unlocked_tea.duplicate()
	available_flavors.resize(max_range)
	var check_flavor = null
	while check_flavor == null:
		check_flavor = available_flavors.pick_random()
	return available_flavors.find(check_flavor)

func _on_books_reload() -> void:
	await drink_served
	get_tree().call_group("Reload", "reload")

func _on_next_customer_timer_timeout() -> void:
	order_text.text = generate_new_order()
	drink_ordered.emit(current_order)

func on_save(save_data: Array[SavedData]) -> void:
	var my_data: SavedGUI = SavedGUI.new()
	my_data.npc_story_progress.append_array(regular_generator.get_progress())
	
	save_data.append(my_data)

func on_load(save_data: SavedData) -> void:
	var my_data: SavedGUI = save_data as SavedGUI
	
	regular_generator.set_progress(my_data.npc_story_progress)
