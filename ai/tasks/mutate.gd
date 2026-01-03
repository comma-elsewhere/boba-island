extends BTAction

func _tick(_delta: float) -> Status:
	var index: int = blackboard.get_var("grow_index")
	var chance: float = blackboard.get_var("mutation_chance")
	
	if index <=3:
		return FAILURE
	else:
	
		agent.mutated = _super_cool_math(chance)
		
		if agent.mutated:
			index += 1
			blackboard.set_var("grow_index", index)
			if index > agent.crop_data.grow_meshes.size():
				return FAILURE
				
			else:
				agent.spawn_physical_crop(index)
				agent.allow_harvest()
				return SUCCESS
				
		elif index > agent.crop_data.grow_meshes.size() -1:
				return FAILURE
		else:
			agent.spawn_physical_crop(index)
			agent.allow_harvest()
			return SUCCESS

func _super_cool_math(percentile_odds: float) -> bool:
	return randf_range(0, 100) > percentile_odds
