extends BTAction

func _tick(_delta: float) -> Status:
	var chance = blackboard.get_var("mutation_chance") * blackboard.get_var("forget") * blackboard.get_var("mutation_mod")
	chance = clampf(chance, 0, 100)
	blackboard.set_var("mutation_chance", chance)
	return SUCCESS
