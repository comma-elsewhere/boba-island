extends Control

@onready var crop_numbers: Label = %CropNumbers
@onready var order_numbers: Label = %OrderNumbers
@onready var order_money: Label = %OrderMoney
@onready var tip_money: Label = %TipMoney
@onready var total_money: Label = %TotalMoney
@onready var pay_button: Button = %PayButton
@onready var payment_options: OptionButton = %PaymentOptions
@onready var debt_progress: DebtProgress = %DebtProgress

var _selected_payment: int = 0

var debt_paid: bool = false

func _ready() -> void:
	_set_labels()
	pay_button.button_up.connect(_pay_debt)
	payment_options.item_selected.connect(_select_payment)
	debt_progress.debt_paid.connect(_debt_paid)

func _set_labels() -> void:
	crop_numbers.text = str(Dynamic.crops_harvested)
	order_numbers.text = str(Dynamic.orders_filled)
	order_money.text = Kinetic.display_money(Dynamic.today_earned)
	tip_money.text = Kinetic.display_money(Dynamic.tips_earned)
	
	Dynamic.total_money += Dynamic.today_earned + Dynamic.tips_earned
	_update_money()
	
func _update_money() -> void:	
	total_money.text = Kinetic.display_money(Dynamic.total_money)
	
func _reset_globals() -> void:
	Dynamic.crops_harvested = 0
	Dynamic.orders_filled = 0
	Dynamic.today_earned = 0
	Dynamic.tips_earned = 0

func _pay_debt() -> void:
	if Dynamic.total_money >= _selected_payment:
		Dynamic.total_money -= _selected_payment
		Dynamic.total_debt -= _selected_payment
		_update_money()
		_update_debt_progress(_selected_payment)
	
func _select_payment(index: int) -> void:
	match index:
		0: _selected_payment = 0
		1: _selected_payment = 500
		2: _selected_payment = 1000
		3: _selected_payment = 2000
		4: _selected_payment = 5000
		5: _selected_payment = 10000
	
	if _selected_payment > Dynamic.total_money:
		pay_button.disabled = true
	else:
		pay_button.disabled = false
	
func _update_debt_progress(amount_paid: int) -> void:
	debt_progress.pay_debt(amount_paid)

func _debt_paid() -> void:
	debt_paid = true
	payment_options.disabled = true
	pay_button.disabled = true
