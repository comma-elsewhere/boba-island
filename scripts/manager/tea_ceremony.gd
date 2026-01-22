extends Node3D

signal cam_switch

# Types of tea available to brew
@export var tea_base: TeaBase

# Tea quality adjustments
@onready var heat_slider: VSlider = %HeatSlider
@onready var brew_timer: Timer = %BrewTimer

# State Machine Calls
@onready var limbo_hsm: LimboHSM = $LimboHSM
@onready var select_state: LimboState = $LimboHSM/SelectState
@onready var boil_state: LimboState = $LimboHSM/BoilState
@onready var water_state: LimboState = $LimboHSM/WaterState
@onready var can_brew_state: LimboState = $LimboHSM/CanBrewState
@onready var brewing_state: LimboState = $LimboHSM/BrewingState
@onready var tea_state: LimboState = $LimboHSM/TeaState

#Display labels
@onready var temp_label: Label = %Temperature
@onready var time_label: Label = %Time
@onready var quality_label: Label = %Quality
# GUI
@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var again_button: Button = %AgainButton
@onready var done_button: Button = %DoneButton

# Max brew time
const BREW := 10.0
const HEAT := 250.0

# Results text
const TEMP: Array[String] = ["Great!", "Too Cold", "Too Hot"]
const TIME: Array[String] = ["Great!", "Too Short", "Too Long"]

# Tea being brewed
var current_tea: Tea = null

func _ready() -> void:
	canvas_layer.hide()

	again_button.button_up.connect(_restart)
	done_button.button_up.connect(_complete)
	
	_init_state_machine() # One-time setup

func _init_state_machine() -> void:
	#State machine transitions
	limbo_hsm.add_transition(select_state, boil_state, "proceed_to_boil")
	limbo_hsm.add_transition(boil_state, water_state, "proceed_to_water")
	limbo_hsm.add_transition(water_state, can_brew_state, "proceed_to_brew")
	limbo_hsm.add_transition(can_brew_state, tea_state, "proceed_to_tea")
	limbo_hsm.add_transition(can_brew_state, brewing_state, "start_brewing")
	limbo_hsm.add_transition(brewing_state, can_brew_state, "stop_brewing")

	limbo_hsm.initial_state = select_state
	limbo_hsm.initialize(self)
	
func start_ceremony() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	canvas_layer.show()
	_setup()
	#Start the state machine
	limbo_hsm.set_active(true)
	
func finish_ceremony() -> void:
	var time = (BREW - brew_timer.time_left) / BREW * 100.0
	var temp = heat_slider.value / HEAT * 100.0
	print(current_tea.perfect_time)
	print(time)
	print(current_tea.perfect_temp)
	print(temp)
	var results = current_tea.set_quality(temp, time)
	_display_results(results, current_tea.quality)

func close() -> void:
	_abort()

func _display_results(results: Array[int], quality: float) -> void:
	quality_label.text = str(int(quality * 100)) + "/100"
	temp_label.text = _set_label_text(TEMP, results[0])
	time_label.text = _set_label_text(TIME, results[1])
	%ResultsDisplay.show()
	
func _set_label_text(strings: Array[String], result: int) -> String:
	match result:
		-1: return strings[1]
		0: return strings[0]
		1: return strings[2]
	return "Unknown"

func _restart() -> void:
	_setup()
	limbo_hsm.change_active_state(select_state)

func _complete() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player") as Player
	player.hud.add_item(current_tea)
	get_tree().call_group("GUI_Event", "close")

func _abort() -> void:
	limbo_hsm.set_active(false)
	canvas_layer.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	heat_slider.value = heat_slider.min_value
	current_tea = null
	
	cam_switch.emit()
	
func _setup() -> void:
	%ResultsDisplay.hide()
	%TeapotLid.show()
	%TeapotPot.set_water()
	current_tea = null
	brew_timer.start(BREW)
	brew_timer.paused = true
	heat_slider.value = heat_slider.min_value
	heat_slider.max_value = HEAT
	
