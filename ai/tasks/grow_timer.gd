extends BTAction

var time: float

func _setup() -> void:
	time = blackboard.get_var("grow_time")

func _tick(delta: float) -> Status:
	time -= delta
	
	agent.set_timer(time)
	
	if time <= 0.02:
		time = blackboard.get_var("grow_time")
		return SUCCESS
	else: 
		return FAILURE
