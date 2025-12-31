extends Node

#Universal Clock --- for coordinating time based events

# Make into a global script
signal minute_changed # Use to sync world time advancing
signal hour_changed(new_hour: int) # Use to sync daily events
signal day_changed(day_number: int, day_name: String) # Use to sync weekly events, signals at end of midnight

# DO NOT CHANGE THESE
const MINUTES_PER_DAY: float = 1440
const MINUTES_PER_HOUR: float = 60
const WEEKDAYS: Array[String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

# Change these to your needs
const INGAME_SPEED := 20.0 # bigger number = faster in game time speed
const INITIAL_HOUR := 6.0 # works in 24 hour time

# DO NOT CHANGE THESE EITHER
var _time:float = 0.0
var _past_minute:int = -1
var _past_hour:int = -1
var _past_day:int = -1

# INITITALIZERS
var world_time: Array[int] = [0, 0, 0]
var current_day: String


func _ready() -> void:
	_time = MINUTES_PER_DAY * MINUTES_PER_HOUR * INITIAL_HOUR


func _process(delta: float) -> void:
	_time += delta * MINUTES_PER_DAY * INGAME_SPEED
	_recalculate_time()


func _recalculate_time() -> void:
	var total_minutes = int(_time / MINUTES_PER_DAY)
	
	var day = int(total_minutes / MINUTES_PER_DAY)

	var current_day_minutes = total_minutes % int(MINUTES_PER_DAY)

	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % int(MINUTES_PER_HOUR))
	
	if _past_minute != minute:
		_past_minute = minute
		world_time = [day, hour, minute]
		minute_changed.emit()
		
		if _past_hour != hour:
			_past_hour = hour
			hour_changed.emit(hour)
			
			if _past_day != day:
				_past_day = day
				day_changed.emit(day, WEEKDAYS[day % 7])
