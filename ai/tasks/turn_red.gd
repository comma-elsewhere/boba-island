extends BTAction

func _tick(_delta: float) -> Status:
	if agent.water_bar.value <= agent.crop_data.water_max:
		agent.modulate_red(true)
	else:
		agent.modulate_red(false)
	
	return SUCCESS
