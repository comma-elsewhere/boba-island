extends BTAction

func _tick(_delta: float) -> Status:
	if agent.water_bar.value < blackboard.get_var("water_min"):
		var chance = blackboard.get_var("mutation_chance") + blackboard.get_var("neglect")
		blackboard.set_var("mutation_chance", chance)
	
	return SUCCESS
