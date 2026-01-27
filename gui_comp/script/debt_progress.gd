class_name DebtProgress extends HBoxContainer

signal debt_paid

@export var curve: Curve
@export_group("Upgrades")
@export var upgrade_0: Array[Upgrade] = []
@export var upgrade_1: Array[Upgrade] = []
@export var upgrade_2: Array[Upgrade] = []
@export var upgrade_3: Array[Upgrade] = []
@export var upgrade_4: Array[Upgrade] = []
@export var upgrade_5: Array[Upgrade] = []
@export var upgrade_6: Array[Upgrade] = []
@export var upgrade_7: Array[Upgrade] = []
@export var upgrade_8: Array[Upgrade] = []
@export var upgrade_9: Array[Upgrade] = []

const SET_DEBT := 200000
const STEPS := 10

var step_amounts: Array[int] = []
var debt_steps: Array[DebtStep] = []
var upgrades_available: Array[Array]

func _ready() -> void:
	upgrades_available = [upgrade_0, upgrade_1, upgrade_2, upgrade_3, upgrade_4, upgrade_5, upgrade_6, upgrade_7, upgrade_8, upgrade_9]
	_calc_steps()
	_set_step_bars()
	debt_steps.front().activate_bar(true)
	
func pay_debt(sub_amount: int) -> void:
	for step in debt_steps:
		step.pay_debt(sub_amount)
	
func _progress_bar(maxed_bar: DebtStep) -> void:
	var index = debt_steps.find(maxed_bar)
	maxed_bar.activate_bar(false)
	index += 1
	if index < STEPS:
		return
	else:
		debt_paid.emit()
	
func _set_step_bars() -> void:
	var step_index: int = 0
	var last_button: UpgradeButton = null
	
	for child in get_children():
		if child.has_method("set_values"):
			child.set_values(step_amounts[step_index])
			child.goal_maxed.connect(_progress_bar)
			debt_steps.append(child)
			if last_button != null:
				last_button.upgrade_selected.connect(child.activate_bar.bind(true))
			
		elif child.has_method("set_control_sibling"):
			last_button = child
			child.set_control_sibling(debt_steps.back())
			child.add_menu_items(step_index, upgrades_available[step_index])
			step_index += 1

func _calc_steps() -> void:
	for i in STEPS:
		var step: float = SET_DEBT * curve.sample_baked(i/10.0)
		step = snappedf(step, 1000)
		step_amounts.append(int(step))
