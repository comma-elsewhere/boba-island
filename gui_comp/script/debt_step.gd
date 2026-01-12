class_name DebtStep extends ProgressBar

signal goal_maxed(myself: DebtStep)

var active: bool = false

func set_values(step_amount: int) -> void:
	max_value = step_amount
	
func pay_debt(amount_changed: float) -> void:
	if active:
		value += amount_changed	
		if value >= max_value:
			goal_maxed.emit(self)
		
func activate_bar(activated: bool) -> void:
	show_percentage = activated
	active = activated
