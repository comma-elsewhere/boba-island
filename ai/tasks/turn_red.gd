extends BTAction

func _tick(_delta: float) -> Status:
	if agent.water_bar.value < blackboard.get_var("water_min"):
		agent.modulate_red(true)
	else:
		agent.modulate_red(false)
	
	return SUCCESS
