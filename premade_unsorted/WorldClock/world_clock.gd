class_name WorldClock

# Make into a global script
signal minute_changed # Use to sync world time advancing
signal hour_changed(new_hour: int) # Use to sync daily events
signal day_changed(day_number: int, day_name: String) # Use to sync weekly events, signals at end of midnight

# DO NOT CHANGE THESE
const MINUTES_PER_DAY: float = 1440
const MINUTES_PER_HOUR: float = 60
const WEEKDAYS: Array[String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

# Change these to your needs
const INGAME_SPEED := 1.0 # bigger number = faster in game time speed
const INITIAL_HOUR := 6.0 # works in 24 hour time

# DO NOT CHANGE THESE EITHER
var time:float = 0.0
var past_minute:int = -1
var past_hour:int = -1
var past_day:int = -1

# INITITALIZERS
var world_time: Array[int] = []
var current_day: String


func _ready() -> void:
	time = MINUTES_PER_DAY * MINUTES_PER_HOUR * INITIAL_HOUR


func _process(delta: float) -> void:
	time += delta * MINUTES_PER_DAY * INGAME_SPEED
	_recalculate_time()


func _recalculate_time() -> void:
	var total_minutes = int(time / MINUTES_PER_DAY)
	
	var day = int(total_minutes / MINUTES_PER_DAY)

	var current_day_minutes = total_minutes % int(MINUTES_PER_DAY)

	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % int(MINUTES_PER_HOUR))
	
	if past_minute != minute:
		past_minute = minute
		world_time = [day, hour, minute]
		minute_changed.emit()
		
		if past_hour != hour:
			past_hour = hour
			hour_changed.emit(hour)
			
			if past_day != day:
				past_day = day
				day_changed.emit(day, WEEKDAYS[day % 7])
