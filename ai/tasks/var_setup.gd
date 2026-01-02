extends BTAction

func _setup() -> void:
	blackboard.set_var("grow_time", agent.crop_data.grow_time * Dynamic.grow_mod)
	blackboard.set_var("mutation_mod", agent.crop_data.mutation_mod)
	blackboard.set_var("water_current", agent.water_bar.value)
	blackboard.set_var("water_max", agent.crop_data.water_max)
	blackboard.set_var("water_min", agent.crop_data.water_min)
	blackboard.set_var("harvest",false)
	blackboard.set_var("dry_time", Dynamic.dry_time)
	blackboard.set_var("moisture_loss", Dynamic.moisture_loss)
	blackboard.set_var("disappoint", Dynamic.disappoint)
	blackboard.set_var("neglect", Dynamic.neglect)
	blackboard.set_var("forget", Dynamic.forget)
