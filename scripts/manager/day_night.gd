extends AnimationPlayer

# Connect commented out code to global world clock
# Make day/night animation 2.4 seconds long for a full 24 hour loop starting at 1am and ending at midnight
var world_clock: WorldClock
var progressed: bool = false

func _ready() -> void:
	current_animation = "day_night"
	world_clock = get_tree().get_first_node_in_group("Clock")
	world_clock.minute_changed.connect(_on_minute_changed)
	
func progress_time():
	progressed = true
	var minutes_passed: float = ((world_clock.world_time[1] * 60.0) + world_clock.world_time[2])
	var advance_by: float = minutes_passed / 60.0 / 10.0
	call_deferred("advance", advance_by)

func _on_minute_changed(_world_time: Array[int]):
	if !progressed:
		progress_time()
	else:
		var minute_conversion: float = 1.0 / 60.0 / 10.0
		advance(minute_conversion)
	
