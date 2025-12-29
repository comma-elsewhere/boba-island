extends Control

signal mandrake_defeated(minigame_solved: bool)

@export var sin_color: Color
@export var square_color: Color
@export var triangle_color: Color

@onready var countdown_timer: Timer = %CountdownTimer
@onready var timer_bar: ProgressBar = %TimerBar
@onready var default_line: Line2D = %DefaultLine
@onready var dynamic_line: Line2D = %DynamicLine
@onready var freq_slider: HSlider = %FreqSlider
@onready var amp_slider: VSlider = %AmpSlider
@onready var sin_button: Button = %SinButton
@onready var square_button: Button = %SquareButton
@onready var triangle_button: Button = %TriangleButton

const COUNTDOWN := 15.0
const ERROR_MARGIN := 350

const LINE_LENGTH:float = 600
const X_SCALE: float = 450
const Y_SCALE: float = 30

enum Waves {SIN, SQAURE, TRIANGLE}

var line_segments: int = 50
var selected_wave
var wave_array: Array[String]

var ready_done: bool = false
var puzzle_solved: bool = false

func _ready() -> void:
	wave_array = ["my_sin", "square", "triangle"]
	_set_values()
	_set_line()
	_modulate_colors()
	_adjust_line(0)
	_start_countdown()
	
	freq_slider.value_changed.connect(_adjust_line)
	amp_slider.value_changed.connect(_adjust_line)
	
	sin_button.pressed.connect(_button_changed.bind(1))
	square_button.pressed.connect(_button_changed.bind(2))
	triangle_button.pressed.connect(_button_changed.bind(3))
	
	ready_done = true
	
func _process(_delta: float) -> void:
	var distance_accuracy: float = 0
	var target_accuracy: float = ERROR_MARGIN
	if !puzzle_solved:
		for i in range(line_segments):
			distance_accuracy += (dynamic_line.points[i].y - default_line.points[i].y)**2
		if distance_accuracy < target_accuracy:
			puzzle_solved = true
	else:
		mandrake_defeated.emit(true)
		# TEMPORARY
		countdown_timer.paused = true
		
		
	timer_bar.value = countdown_timer.time_left
	if countdown_timer.is_stopped() and !puzzle_solved:
		mandrake_defeated.emit(false)
		# TEMPORARY
		get_tree().reload_current_scene()
		
		
func _start_countdown() -> void:
	timer_bar.max_value = COUNTDOWN
	timer_bar.value = COUNTDOWN
	
	countdown_timer.start(COUNTDOWN)
		
func _set_values() -> void:
	randomize()
	freq_slider.value = randf_range(2,6)
	amp_slider.value = randf_range(0,100)
	
func _modulate_colors() -> void:
	sin_button.modulate = sin_color
	square_button.modulate = square_color
	triangle_button.modulate = triangle_color
	
	var button_select := randi_range(1,3)
	_button_changed(button_select)
	
func _button_changed(button_num: int) -> void:
	match button_num:
		1:
			default_line.default_color = sin_color
			selected_wave = Waves.SIN
		2:
			default_line.default_color = square_color
			selected_wave = Waves.SQAURE
		3:
			default_line.default_color = triangle_color
			selected_wave = Waves.TRIANGLE
	
	if ready_done:
		_adjust_line(0)
		
func _set_line() -> void:
	randomize()
	var amp := randf_range(0.2,1)
	var omega = randf_range(2,6)
	
	for i in line_segments:
		default_line.add_point(Vector2.ZERO)
		dynamic_line.add_point(Vector2.ZERO)

	var button_select := randi_range(1,3)
	match button_select:
		1:
			selected_wave = Waves.SIN
		2:
			selected_wave = Waves.SQAURE
		3:
			selected_wave = Waves.TRIANGLE
			
	_line_equation(amp, omega, false)

func _adjust_line(_value: float) -> void:
	var amp = amp_slider.value/100
	var omega = freq_slider.value
	
	_line_equation(amp, omega, true)

func _line_equation(amp: float, omega: float, is_line_real: bool):
	for i:float in range(line_segments):
		var t = i / line_segments
		var line_height = (amp * call(wave_array[selected_wave], (omega * t)))
		if is_line_real:
			default_line.points[i].y = line_height * Y_SCALE + 60
			default_line.points[i].x = t * X_SCALE + 5
		else:
			dynamic_line.points[i].y = line_height * Y_SCALE + 60
			dynamic_line.points[i].x = t * X_SCALE + 5

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
