extends CanvasLayer

signal encounter_end(success: bool)

@onready var timer_bar: ProgressBar = %TimerBar
@onready var red_chrome: HSlider = %RedChrome
@onready var blue_chrome: HSlider = %BlueChrome
@onready var blur_slider: VSlider = %BlurSlider
@onready var countdown_timer: Timer = %CountdownTimer
@onready var shader: ColorRect = %Shader

const COUNTDOWN := 20.0
const ERROR_MARGIN := 8

const COLOR_MAX := 25.0
const BLUR_MAX := 1.25

var puzzle_solved: bool = false

func _ready() -> void:
	get_tree().call_group("Lighting", "mutant_encounter", true)
	get_tree().paused = true
	randomize()
	_set_slider_parameters()
	_set_shader_parameters()
	red_chrome.value_changed.connect(_adjust_value.bind("displace_r"))
	blue_chrome.value_changed.connect(_adjust_value.bind("displace_b"))
	blur_slider.value_changed.connect(_adjust_blur)
	timer_bar.max_value = COUNTDOWN
	countdown_timer.start(COUNTDOWN)
	
func _process(_delta: float) -> void:
	if abs(red_chrome.value) + abs(blue_chrome.value) + abs(blur_slider.value * 10) < ERROR_MARGIN:
		if !puzzle_solved:
			puzzle_solved = true
			_finish_puzzle()
	
	timer_bar.value = countdown_timer.time_left
	countdown_timer.paused = puzzle_solved
	
func _finish_puzzle() -> void:
	get_tree().paused = false
	if !Dynamic.locked_letters.is_empty() and puzzle_solved == true:
		_unlock_letter()
	get_tree().call_group("Lighting", "mutant_encounter", false)
	encounter_end.emit(puzzle_solved)
	call_deferred("queue_free")
	
func _unlock_letter():
	var index:int = Dynamic.locked_letters.pop_front()
	Dynamic.unlocked_book[index] = index + 1
	get_tree().call_group("Reload", "reload")
	
func _adjust_blur(value: float) -> void:
	value = absf(value)
	shader.get_material().set_shader_parameter("lod", value)
	
func _adjust_value(value: float, parameter: String) -> void:
	shader.get_material().set_shader_parameter(parameter, value)
	
func _set_slider_parameters() -> void:
	red_chrome.max_value = COLOR_MAX + randi_range(10, 50)
	red_chrome.min_value = - (COLOR_MAX - randi_range(0, 10))
	blue_chrome.max_value = COLOR_MAX + randi_range(10, 50)
	blue_chrome.min_value = - (COLOR_MAX - randi_range(0, 10))
	blur_slider.max_value = BLUR_MAX + randf_range(0.1, 0.5)
	blur_slider.min_value = - (BLUR_MAX - randf_range(0, 0.1))

func _set_shader_parameters() -> void:
	var rand_seed := randf_range(1, 10)
	shader.get_material().set_shader_parameter("lod", rand_seed / 5)
	shader.get_material().set_shader_parameter("displace_r", _return_value(rand_seed))
	shader.get_material().set_shader_parameter("displace_b", _return_value(rand_seed))
	
	blur_slider.value = shader.get_material().get_shader_parameter("lod")
	red_chrome.value = shader.get_material().get_shader_parameter("displace_r")
	blue_chrome.value = shader.get_material().get_shader_parameter("displace_b")

func _return_value(value: float) -> float:
	var new_value: float = (value/ randf_range(1,5)) * 10 * _rand_neg()
	new_value = clampf(new_value, -COLOR_MAX, COLOR_MAX)
	return new_value

func _rand_neg() -> int:
	return [-1,1].pick_random()

func _on_countdown_timer_timeout() -> void:
	_finish_puzzle()
