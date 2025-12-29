extends MarginContainer

signal puzzle_is_solved

@export var current_song: AudioStreamPlayer
@export var real_line: Line2D
@export var imaginary_line: Line2D
@export var play_button: Button
@export_subgroup("Slider")
@export var horizontal_slider: HSlider
@export var vertical_slider: VSlider
@export_subgroup("Button")
@export var button_one: Button
@export var button_two: Button
@export var button_three: Button
@export var button_four: Button
@export_subgroup("Colors")
@export var button_color_one: Color
@export var button_color_two: Color
@export var button_color_three: Color
@export var button_color_four: Color

const ERROR_MARGIN = 350

const LINE_LENGTH:float = 560
const X_SCALE: float = 560
const Y_SCALE: float = 10

enum Waves {SIN, SQAURE, TRIANGLE, SAWTOOTH}

var line_segments: int = 50
var selected_wave
var wave_array: Array[String]

var ready_done: bool = false
var puzzle_solved: bool = false

func _ready() -> void:
	wave_array = ["my_sin", "square", "triangle", "sawtooth"]
	_set_values()
	_set_line()
	_modulate_colors()
	_adjust_line(0)
	play_button.disabled = true
	
	horizontal_slider.value_changed.connect(_adjust_line)
	vertical_slider.value_changed.connect(_adjust_line)
	
	button_one.pressed.connect(_button_changed.bind(1))
	button_two.pressed.connect(_button_changed.bind(2))
	button_three.pressed.connect(_button_changed.bind(3))
	button_four.pressed.connect(_button_changed.bind(4))
	
	ready_done = true
	
func _process(_delta: float) -> void:
	var distance_accuracy: float = 0
	var target_accuracy: float = ERROR_MARGIN
	if !puzzle_solved:
		for i in range(line_segments):
			distance_accuracy += (imaginary_line.points[i].y - real_line.points[i].y)**2
		if distance_accuracy < target_accuracy:
			puzzle_solved = true
	else:
		puzzle_is_solved.emit()
		_disable_enable_buttons()
		
func _set_values() -> void:
	randomize()
	horizontal_slider.value = randf_range(2,6)
	vertical_slider.value = randf_range(50, 400)
	
func _modulate_colors() -> void:
	button_one.modulate = button_color_one
	button_two.modulate = button_color_two
	button_three.modulate = button_color_three
	button_four.modulate = button_color_four
	
	var button_select := randi_range(1,4)
	_button_changed(button_select)
	
func _button_changed(button_num: int) -> void:
	match button_num:
		1:
			real_line.default_color = button_color_one
			selected_wave = Waves.SIN
		2:
			real_line.default_color = button_color_two
			selected_wave = Waves.SQAURE
		3:
			real_line.default_color = button_color_three
			selected_wave = Waves.TRIANGLE
		4:
			real_line.default_color = button_color_four
			selected_wave = Waves.SAWTOOTH
	
	if ready_done:
		_adjust_line(0)
		
func _set_line() -> void:
	randomize()
	var amp := randf_range(0,1)
	var omega = randf_range(2,6)
	
	for i in line_segments:
		real_line.add_point(Vector2.ZERO)
		imaginary_line.add_point(Vector2.ZERO)

	var button_select := randi_range(1,4)
	match button_select:
		1:
			selected_wave = Waves.SIN
		2:
			selected_wave = Waves.SQAURE
		3:
			selected_wave = Waves.TRIANGLE
		4:
			selected_wave = Waves.SAWTOOTH
			
	_line_equation(amp, omega, false)

func _adjust_line(_value: float) -> void:
	var amp = vertical_slider.value/100
	var omega = horizontal_slider.value
	
	_line_equation(amp, omega, true)

func _line_equation(amp: float, omega: float, is_line_real: bool):
	for i:float in range(line_segments):
		var t = i / line_segments
		var line_height = (amp * call(wave_array[selected_wave], (omega * t)))
		if is_line_real:
			real_line.points[i].y = line_height * Y_SCALE + 100
			real_line.points[i].x = t * X_SCALE + 18
		else:
			imaginary_line.points[i].y = line_height * Y_SCALE + 100
			imaginary_line.points[i].x = t * X_SCALE + 18
		
func _disable_enable_buttons() -> void:
	play_button.disabled = false
	
		
func my_sin(x : float):
	return sin(x*2*PI)

func square(x : float):
	if fmod(x, 1.0) < 0.5:
		return 1
	else:
		return -1

func sawtooth(x : float):
	return 1-fmod(x, 1)*2

func triangle(x : float):
	var a = fmod(x, 1) + .25
	if a < 0.5:
		return -1 + a * 4
	else:
		return 3 - a * 4
