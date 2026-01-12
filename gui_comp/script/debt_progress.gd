class_name DebtProgress extends HBoxContainer

@export var curve: Curve

const SET_DEBT := 200080
const STEPS := 10

var step_amounts: Array[int] = []
var debt_steps: Array[DebtStep] = []

func _ready() -> void:
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
		debt_steps[index].activate_bar(true)
	else:
		print("DONE")
	
func _set_step_bars() -> void:
	var step_index: int = 0
	
	for child in get_children():
		if child.has_method("set_values"):
			child.set_values(step_amounts[step_index])
			child.goal_maxed.connect(_progress_bar)
			step_index += 1
			debt_steps.append(child)
			
		elif child.has_method("set_control_sibling"):
			child.set_control_sibling(debt_steps.back())

func _calc_steps() -> void:
	for i in STEPS:
		var step: float = SET_DEBT * curve.sample_baked(i/10.0)
		step = snappedf(step, 1000)
		step_amounts.append(int(step))
