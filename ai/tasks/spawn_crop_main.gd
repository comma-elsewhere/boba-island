extends BTAction

func _tick(_delta: float) -> Status:
	var index = blackboard.get_var("grow_index")
	agent.spawn_physical_crop(index)
	index += 1
	blackboard.set_var("grow_index", index)
	return SUCCESS
