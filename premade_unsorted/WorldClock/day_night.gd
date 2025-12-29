extends AnimationPlayer

# Connect commented out code to global world clock
# Make day/night animation 2.4 seconds long for a full 24 hour loop starting at 1am and ending at midnight

#func _ready() -> void:
	#var minutes_passed: float = ((GClock.world_time[1] * 60.0) + GClock.world_time[2])
	#var advance_by: float = minutes_passed / 60.0 / 10.0
	#call_deferred("advance", advance_by)
	#GClock.minute_changed.connect(_on_minute_changed)

func _on_minute_changed():
	var minute_conversion: float = 1.0 / 60.0 / 10.0
	advance(minute_conversion)
