extends BTAction

func _tick(_delta: float) -> Status:
	if agent.water_bar.value > blackboard.get_var("water_max"):
		return SUCCESS
	else:
		var chance = blackboard.get_var("mutation_chance") + blackboard.get_var("disappoint")
		blackboard.set_var("mutation_chance", chance)
		return FAILURE
