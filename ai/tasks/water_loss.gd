extends BTAction

func _tick(_delta: float) -> Status:
	var water = blackboard.get_var("water_current") - blackboard.get_var("moisture_loss")
	blackboard.set_var("water_current", water)
	agent.reduce_water(water)
	return SUCCESS
