extends VBoxContainer

@onready var day_time: Label = $DayTime
@onready var money: Label = $Money


var day: String
var hour: int
var minute: int

const WEEKDAYS: Array[String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

func _ready() -> void:
	get_tree().get_first_node_in_group("Clock").minute_changed.connect(_update_time)
	
func _process(_delta: float) -> void:
	day_time.text = day + ", " + Kinetic.display_time(hour, minute)
	money.text = Kinetic.display_money(Dynamic.total_money)
	
func _update_time(world_time: Array[int]):
	var day_num = world_time[0]
	day = WEEKDAYS[day_num % 7]
	hour = world_time[1]
	minute = world_time[2]
