extends VBoxContainer

@onready var day_time: Label = $DayTime
@onready var money: Label = $Money


var day: String
var hour: int
var minute: int
var minute_string: String
var money_string: String

func _ready() -> void:
	Cleric.minute_changed.connect(_update_time)
	
func _process(_delta: float) -> void:
	if minute < 10:
		minute_string = "0" + str(minute)
	else:
		minute_string = str(minute)
	
		
	day_time.text = day + ", " + str(hour) + ":" + minute_string
	money.text = "$%.2f" % (float(Dynamic.total_money)/100)
	
func _update_time():
	day = Cleric.current_day
	hour = Cleric.world_time[1]
	minute = Cleric.world_time[2]
