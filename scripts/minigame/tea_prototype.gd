extends Node2D

@onready var gaiwan: Area2D = $Gaiwan
@onready var teapot: Area2D = $Teapot
@onready var teacup: Area2D = $Teacup
@onready var loose_tea: Area2D = $LooseTea
@onready var audio: AudioStreamPlayer = %AudioStreamPlayer

@onready var heat_slider: VSlider = %HeatSlider
@onready var tea_shape: Sprite2D = %TeaShape
@onready var brew_time: Timer = %BrewTime
@onready var display: Marker2D = %Display
@onready var temp_label: Label = %TempLabel
@onready var brew_label: Label = %BrewLabel


@export var temp_quality: Array[String] = ["Perfect", "Mildly Off-putting", "Very Strange", "Wrong", "Very Upsetting"]
@export var brew_quality: Array[String] = ["Perfect", "Pretty good", "A Little Off", "Bad", "Disgusting"]
@export_range(0, 100, 5) var perfect_temp: float = 80
@export_range(0, 100, 5) var perfect_brew: float = 60

@export var boiling_sound: AudioStream
@export var pouring_sound: AudioStream
@export var clinking_sound: AudioStream

var final_qualities: Array[String] = []

var can_brew: bool = false
var has_tea: bool = false
var tea_brewing: bool = false

func _ready() -> void:
	display.hide()
	teapot.mouse_click.connect(_pour_water)
	teacup.mouse_click.connect(_pour_tea)
	gaiwan.mouse_click.connect(_brew_tea)
	gaiwan.tea_got.connect(_get_tea)
	heat_slider.value_changed.connect(_boil_water)
	tea_shape.scale = Vector2(heat_slider.value, heat_slider.value)
	
func _process(_delta: float) -> void:
	if tea_brewing:
		tea_shape.modulate.a = (10.0 - brew_time.time_left) / 10.0

func _get_tea() -> void:
	has_tea = true
	tea_shape.reparent(gaiwan)
	tea_shape.position = Vector2.ZERO
	loose_tea.queue_free()

func _brew_tea() -> void:
	if can_brew:
		audio.stream = clinking_sound
		brew_time.start()
		audio.play()
		tea_brewing = true
	
func _boil_water(value: float) -> void:
	if !can_brew and has_tea:
		tea_shape.scale = Vector2(value, value)
		if !audio.playing:
			audio.stream = boiling_sound
			audio.play()
	
func _pour_water() -> void:
	if !can_brew and has_tea:
		audio.stop()
		audio.stream = pouring_sound
		audio.play()
		can_brew = true
	
func _pour_tea() -> void:
	if can_brew:
		audio.stop()
		audio.stream = pouring_sound
		audio.play()
		tea_brewing = false
		tea_shape.reparent(teacup)
		tea_shape.position = Vector2.ZERO
		can_brew = false
		has_tea = false
		_evaluate(heat_slider.value, 10.0 - brew_time.time_left)
	
func _evaluate(temp: float, brewed: float) -> void:
	var percent_temp = ((temp - .04) / .08) * 100
	var percent_brewed = brewed * 10.0
	print(percent_temp)
	print(percent_brewed)
	
	_assign_qualities(_check_distance(perfect_temp, percent_temp), temp_quality)
	_assign_qualities(_check_distance(perfect_brew, percent_brewed), brew_quality)
	_display_qualities()
	
func _display_qualities():
	display.show()
	temp_label.text = final_qualities[0]
	brew_label.text = final_qualities[1]

func _assign_qualities(dist: float, qualities: Array[String]) -> void:
	print(dist)
	
	var quality: String
	if dist < 10:
		quality = qualities[0]
	elif dist < 20:
		quality = qualities[1]
	elif dist < 30:
		quality = qualities[2]
	elif dist < 50:
		quality = qualities[3]
	else:
		quality = qualities[4]
		
	final_qualities.append(quality)
	
func _check_distance(perfect: float, actual: float) -> float:
	var distance: float = absf(actual - perfect)
	return distance

func _on_retry_button_button_up() -> void:
	get_tree().reload_current_scene()
