extends BTAction

func _tick(_delta: float) -> Status:
	var water = agent.water_bar.value - blackboard.get_var("moisture_loss")
	blackboard.set_var("water_current", water)
	agent.reduce_water(water)
	return SUCCESS
